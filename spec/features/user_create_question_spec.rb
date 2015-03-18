require 'rails_helper'

feature 'User sign in', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do
  scenario 'Authenticated user creates a question' do
    user = create(:user)

    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question title'
    fill_in 'Body', with: 'Test question body'
    click_on 'Create'
    expect(page).to have_content I18n.t('question.created')

    # Пользователь видит содержимое созданного вопроса,
    # находится на нужной странице
  end

  scenario 'Non-authenticated user tries to create a question' do
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question title'
    fill_in 'Body', with: 'Test question body'
    click_on 'Create'

    expect(page).to have_content I18n.t(:unauthenticated, scope: 'devise.failure')
  end
end
