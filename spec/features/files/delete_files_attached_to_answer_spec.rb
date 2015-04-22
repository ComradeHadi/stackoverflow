require 'features/helper'

feature 'Delete file attached to answer', %q(
  As answer author
  I want to be able to delete file I've attached to my answer
) do
  given(:answer) { create(:answer, :with_files, files_count: 2) }
  given(:question) { answer.question }
  given(:file) { answer.attachments.first }
  given(:author) { answer.user }
  given(:other_user) { create(:user) }

  scenario 'Author can delete files attached to his answer', js: true do
    log_in author
    visit question_path question
    expect(page).to have_content file.file_identifier, count: 2
    click_link 'Delete file', match: :first
    click_link 'Delete file'
    expect(current_path).to eq question_path(question)
    expect(page).not_to have_content file.file_identifier
  end

  scenario 'Other users can not delete files attached to a answer' do
    log_in other_user
    visit question_path question
    expect(page).to have_content file.file_identifier, count: 2
    expect(page).not_to have_link 'Delete file'
  end

  scenario 'Guests can not delete files attached to a answer' do
    visit question_path question
    expect(page).to have_content file.file_identifier, count: 2
    expect(page).not_to have_link 'Delete file'
  end
end
