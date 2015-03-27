require 'features/helper'

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

