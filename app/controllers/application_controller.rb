class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    if request.xhr?
      if signed_in?
        action = exception.action
        resource = exception.subject.class.to_s.pluralize
        error_message = "You don't have permission to #{ action } #{ resource }"
        render status: :forbidden, text: error_message
      else
        error_message = "You must log in first"
        render status: :unauthorized, text: error_message
      end
    else
      render status: :forbidden, file: "public/403.html"
    end
  end

  check_authorization :unless => :devise_controller?
end
