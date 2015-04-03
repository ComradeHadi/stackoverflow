require 'rails_helper'

feature 'User sign out', %q{
  As an authenticated user
  I want to be able to sign-out
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user sign out' do
    log_in user
    expect(current_path).to eq root_path
    log_out user
    expect(page).to have_content t('devise.sessions.signed_out')
  end
end

