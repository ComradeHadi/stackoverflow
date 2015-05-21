class API::V1::BaseController < ApplicationThinController
  before_action :doorkeeper_authorize!

  skip_authorization_check

  respond_to :json

  protected

  def current_user
    @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
