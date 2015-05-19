require 'features/helper'

feature 'Sign in with Twitter', %q(
  As a Twitter user
  I want to be able to sign in with my Twitter account
) do
  given(:user) { create :user }
  given(:new_user) { build :user }
  given(:identity) { create :identity, provider: 'twitter', uid: Faker::Code.ean }
  given(:email_field) { 'Email' }
  given(:password_field) { 'Password' }
  given(:submit_label) { 'Confirm' }
  given(:confirmation_required_label) { 'Please confirm your account' }
  given(:provider) { 'twitter' }
  given(:link_sign_in_with_provider) { "Sign in with #{ provider.capitalize }" }
  given(:link_logout) { 'log out' }
  given(:notice_success) { t('devise.omniauth_callbacks.success', kind: provider.capitalize) }
  given(:notice_welcome) { t('devise.registrations.signed_up') }
  given(:email_confirmation_label) { 'confirm your account email' }

  context 'Existing User signs in from Twitter' do
    scenario 'with existing identity', js: true do
      oauth_provider(provider, uid: identity.uid)

      visit new_user_session_path
      click_on link_sign_in_with_provider

      expect(current_path).to eq root_path
      expect(page).to have_content notice_success
      expect(page).to have_content link_logout
    end

    scenario 'without identity', js: true do
      oauth_provider(provider, uid: Faker::Code.ean)

      visit new_user_session_path
      click_on link_sign_in_with_provider

      expect(current_path).to eq new_user_registration_path
      expect(page).to_not have_field :password_label

      fill_in email_field, with: user.email
      click_on submit_label

      expect(current_path).to eq identity_path Identity.last
      expect(page).to have_content confirmation_required_label

      last_email = ActionMailer::Base.deliveries.last
      expect(last_email.encoded).to have_content :email_confirmation_label

      # visit confirmation url from email is not working correctly from rspec
      confirmation_token = last_email.encoded.match(/token=(\w+)/)[1]
      visit confirm_identities_path(token: confirmation_token)

      expect(current_path).to eq root_path
      expect(page).to have_content notice_success
      expect(page).to have_content link_logout
    end
  end

  scenario 'New user signs in from Twitter', js: true do
    oauth_provider(provider, uid: Faker::Code.ean)

    visit new_user_session_path
    click_on link_sign_in_with_provider

    expect(current_path).to eq new_user_registration_path
    expect(page).to_not have_field :password_label

    fill_in email_field, with: new_user.email
    click_on submit_label

    expect(current_path).to eq root_path
    expect(page).to have_content notice_welcome
    expect(page).to have_content link_logout
  end
end
