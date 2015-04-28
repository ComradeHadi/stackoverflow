require 'features/helper'

feature 'Add files to answer', %q(
  As answer author
  I want to be able to add files to answer
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:attributes) { attributes_for(:answer) }
  given(:label_body) { t('answer.label.body') }
  given(:label_file) { t('attachment.label.file') }
  given(:link_new_attachment) { t('attachment.action.new') }
  given(:submit_new_answer) { t('answer.action.confirm.new') }
  given(:first_answer) { '.answers .answer:first-child' }
  given(:test_file_name) { 'helper.rb' }
  given(:test_file) { "#{Rails.root}/spec/features/#{ test_file_name }" }

  background do
    log_in user
    visit question_path question
  end

  scenario 'Author adds files when posting an answer', js: true do
    fill_in label_body, with: attributes[:body]

    2.times do |n|
      click_on link_new_attachment
      within ".attachments_form .fields:nth-child(#{ n + 1 })" do
        attach_file label_file, test_file
      end
    end
    click_on submit_new_answer

    within first_answer do
      expect(page).to have_link test_file_name, count: 2
    end
  end
end
