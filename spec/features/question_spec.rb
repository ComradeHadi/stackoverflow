require 'rails_helper'

feature 'View questions', %q{
  As a guest
  I want to be able to view existing questions
} do

  given(:user) { create(:user) }
  given(:questions) { create_list(:question, 3) }
  before { questions }

  scenario 'Any guest can view questions' do
    visit questions_path
    expect(current_path).to eq questions_path
    expect(page).to have_content I18n.t('questions.found', count: questions.count)
  end

  scenario 'Authenticated user can view questions' do
    log_in user
    visit questions_path
    expect(page).to have_content I18n.t('questions.found', count: questions.count)
  end
end

feature 'Create question', %q{
  As an authenticated user
  I want to be able to ask a question
} do

  given(:user) { create(:user) }
  given(:question) { build(:question) }

  scenario 'Authenticated user creates a question' do
    log_in user

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on 'Create'

    expect(page).to have_content I18n.t('question.created')
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'Guest can not create a question' do
    visit questions_path
    click_on 'Ask question'
    expect(current_path).to eq new_user_session_path
    expect(page).to have_content I18n.t('devise.failure.unauthenticated')
  end
end

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

feature 'Update question', %q{
  As an author
  I want to be able to edit my question
} do

  given(:author) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: author) }
  before { question }

  scenario 'Author can edit his question' do
    log_in author
    visit question_path(question)
    click_on 'Edit question'
    expect(current_path).to eq edit_question_path(question)
    fill_in 'Title', with: 'Updated title'
    fill_in 'Body', with: 'Updated body'
    click_on 'Update'
    expect(current_path).to eq question_path(question)
    expect(page).to have_content I18n.t('question.updated')
  end
  scenario 'Users can not edit question of another user' do
    log_in other_user
    visit question_path(question)
    click_on 'Edit question'
    expect(current_path).to eq question_path(question)
    expect(page).to have_content I18n.t('question.failure.not_an_author')
  end
  scenario 'Guest can not edit any questions' do
    visit question_path(question)
    click_on 'Edit question'
    expect(current_path).to eq new_user_session_path
    expect(page).to have_content I18n.t('devise.failure.unauthenticated')
  end
end

