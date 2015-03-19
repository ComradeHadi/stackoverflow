require 'rails_helper'

feature 'Delete question', %q{
  As an author
  I want to be able to delete my question
} do

  given(:author) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: author) }
  before { question }

  scenario 'Author can delete his question' do
    log_in author
    visit question_path(question)
    click_on 'Delete question'
    expect(page).to have_content I18n.t('question.destroyed')
    expect(current_path).to eq questions_path
  end
  scenario 'Users can not delete question of another user' do
    log_in other_user
    visit question_path(question)
    click_on 'Delete question'
    expect(page).to have_content I18n.t('question.failure.not_an_author')
    expect(current_path).to eq question_path(question)
  end
  scenario 'Guest can not delete any questions' do
    visit question_path(question)
    click_on 'Delete question'
    expect(current_path).to eq new_user_session_path
    expect(page).to have_content I18n.t('devise.failure.unauthenticated')
  end
end

