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

feature 'User sign out', %q{
  As an authenticated user
  I want to be able to sign-out
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user sign out' do
    log_in user
    expect(current_path).to eq root_path
    log_out user
    expect(page).to have_content I18n.t('devise.sessions.signed_out')
  end
end

feature 'Register', %q{
  As a guest
  I want to be able to register
} do

  given(:user) { build(:user) }

  scenario 'Guest is registered' do
    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'
    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t('devise.registrations.signed_up')
  end
end

