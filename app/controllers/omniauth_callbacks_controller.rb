class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def provider
    @user = User.find_for_auth request.env['omniauth.auth']

    if @user.persisted?
      user_sign_in
    else
      require_email_confirmation
    end
  end

  Devise.omniauth_providers.each do |provider|
    alias_method provider, :provider
    public provider
  end

  private :provider

  private

  def user_sign_in
    provider_name = request.env['omniauth.auth'].provider.capitalize
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: provider_name) if is_navigational_format?
  end

  def require_email_confirmation
    session['devise.require_email_confirmation'] = true
    session['devise.identity.id'] = @user.identities.first.id
    redirect_to new_user_registration_url
  end
end
