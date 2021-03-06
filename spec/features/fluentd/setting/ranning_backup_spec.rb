require "spec_helper"

describe "running_backup", stub: :daemon do
  let!(:exists_user) { build(:user) }
  include_context 'daemon has some config histories'

  before do
    login_with exists_user
  end

  context 'has running backup file' do
    before do
      visit '/daemon/setting/running_backup'
    end

    describe 'show' do
      it 'has no content, no reuse bottun' do
        expect(page).to have_text(I18n.t('fluentd.common.never_started_yet', brand: 'fluentd'))
        expect(page).not_to have_css('pre')
        expect(page).not_to have_text(I18n.t("terms.reuse"))
      end
    end
  end

  context 'has running backup file' do
    include_context 'daemon had been started once'

    before do
      visit '/daemon/setting/running_backup'
    end

    describe 'show' do
      it 'has content, reuse bottun' do
        expect(page).not_to have_text(I18n.t('fluentd.common.never_started_yet', brand: 'fluentd'))
        expect(page).to have_text(backup_content)
        expect(page).to have_text(I18n.t("terms.reuse"))
      end

      it 'update config and redirect to setting#show' do
        click_link I18n.t("terms.reuse")

        page.should have_css('h1', text: I18n.t('fluentd.settings.show.page_title'))
        page.should have_text(I18n.t('messages.config_successfully_copied', brand: 'fluentd') )
        page.should have_text(backup_content)
      end
    end
  end
end
