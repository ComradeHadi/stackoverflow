module DeviseHelper
  def log_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def log_out
    page.driver.submit :delete, destroy_user_session_path, {}
  end
end
