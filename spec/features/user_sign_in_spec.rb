require 'rails_helper'

feature 'User sign in', %q{
  In order to be able to ask questions
  As a user
  I want to be able to sign-in
} do
  scenario 'Registered user try to sign in' do
    # let(:user) = { create(:user) }

    valid_email = 'user@test.com'
    valid_password = '12345678'

    User.create!(email: valid_email, password: valid_password)

    visit new_user_session_path
    fill_in 'Email', with: valid_email
    fill_in 'Password', with: valid_password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully'
    expect(current_path).to eq root_path
  end

  scenario 'Non-requstered user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong_email@non_existent.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'
save_page
    expect(page).to have_content 'Invalid email or password'
    expect(current_path).to eq new_user_session_path
  end
end
