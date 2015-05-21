class API::V1::ProfilesController < API::V1::BaseController
  def index
    respond_with User.all_except current_user
  end

  def me
    respond_with current_user
  end
end
