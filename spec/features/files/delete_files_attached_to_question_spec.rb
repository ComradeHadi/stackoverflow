require 'features/helper'

feature 'Delete file attached to question', %q{
  As question author
  I want to be able to delete file I've attached to my question
} do

  given(:question) { create(:question_with_attachment) }
  given(:file) { question.attachments.first }
  given(:author) { question.user }
  given(:other_user) { create(:user) }

  scenario 'Author can delete files attached to his question', js: true do
    log_in author
    visit question_path question
    expect(page).to have_content file.file_identifier
    click_on 'Delete file'
    expect(current_path).to eq question_path(question)
    expect(page).not_to have_content file.file_identifier
  end

  scenario 'Other users can not delete files attached to a question' do
    log_in other_user
    visit question_path question
    expect(page).to have_content file.file_identifier
    expect(page).not_to have_link 'Delete file'
  end

  scenario 'Guests can not delete files attached to a question' do
    visit question_path question
    expect(page).to have_content file.file_identifier
    expect(page).not_to have_link 'Delete file'
  end
end
