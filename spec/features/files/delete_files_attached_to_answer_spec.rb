require 'features/helper'

feature 'Delete file attached to answer', %q(
  As answer author
  I want to be able to delete file I've attached to my answer
) do
  given!(:answer) { create(:answer, :with_files, files_count: 2) }
  given(:question) { answer.question }
  given(:link_delete_attachment) { t('attachment.action.delete') }
  given(:attachment_file_name) { answer.attachments.first.file_identifier }
  given(:user) { create(:user) }

  scenario 'Author deletes files attached to his answer', js: true do
    log_in answer.author
    visit question_path question
    expect(page).to have_content attachment_file_name, count: 2

    click_on link_delete_attachment, match: :first
    click_on link_delete_attachment

    expect(current_path).to eq question_path question
    expect(page).to_not have_content attachment_file_name
  end

  scenario 'User can not delete files attached to an answer' do
    log_in user
    visit question_path question
    expect(page).to have_content attachment_file_name, count: 2
    expect(page).to_not have_link link_delete_attachment
  end

  scenario 'Guest can not delete files attached to an answer' do
    visit question_path question
    expect(page).to have_content attachment_file_name, count: 2
    expect(page).to_not have_link link_delete_attachment
  end
end
