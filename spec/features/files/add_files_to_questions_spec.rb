require 'features/helper'

feature 'Add files to question', %q(
  As question author
  I want to be able to add files to question
) do
  given(:user) { create(:user) }
  given(:attributes) { attributes_for(:question) }
  given(:label_title) { t('question.label.title') }
  given(:label_body) { t('question.label.body') }
  given(:label_file) { t('attachment.label.file') }
  given(:link_new_attachment) { t('attachment.action.new') }
  given(:submit_new_question) { t('question.action.confirm.new') }
  given(:notice_created) { t('flash.actions.create.notice', resource_name: 'Question') }
  given(:test_file_name) { 'helper.rb' }
  given(:test_file) { "#{Rails.root}/spec/features/#{ test_file_name }" }

  background do
    log_in user
    visit new_question_path
  end

  scenario 'Author adds files when asking a question', js: true do
    fill_in label_title, with: attributes[:title]
    fill_in label_body, with: attributes[:body]

    2.times do |n|
      click_link link_new_attachment
      within ".attachments_form .fields:nth-child(#{ n + 1 })" do
        attach_file label_file, test_file
      end
    end
    click_on submit_new_question

    expect(page).to have_content notice_created
    expect(page).to have_link test_file_name, count: 2
  end
end
