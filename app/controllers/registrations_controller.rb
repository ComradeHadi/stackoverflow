class RegistrationsController < Devise::RegistrationsController
  before_action :load_identity, only: :create

  def create
    if @identity
      email = sign_up_params[:email]
      if User.exists?(email: email)
        @identity.require_confirmation email
        redirect_to identity_path @identity
        return
      end
    end

    super { |user| user.identities << @identity if @identity }
  end

  protected

  def build_resource(hash = nil)
    super
    resource.no_password = session['devise.identity.id'].present?
  end

  private

  def load_identity
    identity_id = session['devise.identity.id']
    return unless identity_id

    @identity = Identity.find(identity_id)
  end
end
