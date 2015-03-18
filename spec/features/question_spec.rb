require 'rails_helper'

feature 'View questions', %q{
  As a guest
  I want to be able to view existing questions
} do
  scenario 'Any user can view questions' do
    questions = create_list(:question, 3)

    visit questions_path
    expect(page).to have_content 'Questions found: 3'
  end
end

feature 'Create questions', %q{
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates a question' do
    question = build(:question)    

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

  scenario 'Guest tries to create a question' do
    visit questions_path
    click_on 'Ask question'
    expect(page).to have_content I18n.t('devise.failure.unauthenticated')
  end
end
