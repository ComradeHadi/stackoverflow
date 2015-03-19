require 'rails_helper'

feature 'User sign in', %q{
  As a user
  I want to be able to sign-in
} do

  given(:user) { create(:user) }

  scenario 'Registered user sign in' do
    log_in user
    expect(page).to have_content I18n.t('devise.sessions.signed_in')
    expect(current_path).to eq root_path
  end

  scenario 'Non-requstered user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong_email@non_existent.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'
    expect(page).to have_content I18n.t('devise.failure.invalid', authentication_keys: 'email')
    expect(current_path).to eq new_user_session_path
  end
end

