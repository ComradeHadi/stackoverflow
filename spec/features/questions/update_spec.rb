require 'features/helper'

feature 'Update question', %q(
  As an author
  I want to be able to edit my question without page reload
) do
  given(:author) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: author) }

  scenario 'Author can edit his question without page reload', js: true do
    log_in author
    visit question_path(question)
    click_on 'Edit question'
    expect(current_path).to eq question_path(question)
    fill_in 'Title', with: 'Updated title'
    fill_in 'Body', with: 'Updated body'
    click_on 'Update'
    expect(current_path).to eq question_path(question)
    expect(page).to have_content t('question.updated')
  end

  scenario 'Users can not edit question of another user' do
    log_in other_user
    visit question_path(question)
    expect(page).not_to have_link('Edit question')
  end

  scenario 'Guest can not edit any questions' do
    visit question_path(question)
    expect(page).not_to have_link('Edit question')
  end
end
