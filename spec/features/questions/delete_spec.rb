require 'features/helper'

feature 'Delete question', %q{
  As an author
  I want to be able to delete my question
} do

  given(:author) { create(:user) }
  given(:other_user) { create(:user) }
  given(:questions) { create_list(:question, 3, user: author) }
  given!(:question) { questions.at(2) }

  scenario 'Author can delete his question from index page (with ajax)' do
    log_in author
    visit questions_path
    click_on "delete_question_#{ question.id }"
    expect(current_path).to eq questions_path
    expect(page).not_to have_content question.title
  end
  scenario 'Author can delete his question from show page' do
    log_in author
    visit question_path(question)
    click_on 'Delete question'
    expect(page).to have_content I18n.t('question.destroyed')
    expect(current_path).to eq questions_path
  end
  scenario 'Users can not delete question of another user' do
    log_in other_user
    visit question_path(question)
    expect(page).not_to have_link('Delete question')
  end
  scenario 'Guest can not delete any questions' do
    visit question_path(question)
    expect(page).not_to have_link('Delete question')
  end
end

