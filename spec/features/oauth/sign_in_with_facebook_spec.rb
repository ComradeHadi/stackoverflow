require 'features/helper'

feature 'Sign in with Facebook', %q(
  As a Facebook user
  I want to be able to sign in with my Facebook account
) do
  given(:user) { create :user }
  given(:new_user) { build :user }
  given(:provider) { 'facebook' }
  given(:link_sign_in_with_provider) { "Sign in with #{ provider.capitalize }" }
  given(:notice_success) { t('devise.omniauth_callbacks.success', kind: provider.capitalize) }
  given(:link_logout) { 'log out' }

  scenario 'Existsing user signs in from Facebook' do
    oauth_provider(provider, info: { email: user.email })

    visit new_user_session_path
    click_on link_sign_in_with_provider

    expect(current_path).to eq root_path
    expect(page).to have_content notice_success
    expect(page).to have_content link_logout
  end

  scenario 'New user signs in from Facebook' do
    oauth_provider(provider, info: { email: new_user.email })

    visit new_user_session_path
    click_on link_sign_in_with_provider

    expect(current_path).to eq root_path
    expect(page).to have_content notice_success
    expect(page).to have_content link_logout
  end
end
