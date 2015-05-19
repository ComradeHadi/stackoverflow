class IdentitiesController < ApplicationController
  skip_authorization_check

  before_action :load_identity, only: :show
  before_action :check_identity_require_confirmation, only: :show
  before_action :load_identity_by_token, only: :confirm

  def show
  end

  def confirm
    @identity.confirm!
    user_sign_in if @identity.user
  end

  private

  def load_identity
    @identity = Identity.find(params[:id])
  end

  def check_identity_require_confirmation
    render status: :bad_request, nothing: true unless @identity.confirmation_token
  end

  def load_identity_by_token
    @identity = Identity.find_by(confirmation_token: params[:token])
    render :confirm, status: :bad_request unless @identity
  end

  def user_sign_in
    provider_name = @identity.provider.capitalize
    flash[:notice] = t(:success, scope: 'devise.omniauth_callbacks', kind: provider_name)
    sign_in_and_redirect @identity.user, event: :authentication
  end
end
