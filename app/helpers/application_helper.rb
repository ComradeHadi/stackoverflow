module ApplicationHelper
  def current_user_author_of?(resource)
    user_signed_in? && (current_user.author_of? resource)
  end
end
