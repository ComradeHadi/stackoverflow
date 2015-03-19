require 'rails_helper'

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

