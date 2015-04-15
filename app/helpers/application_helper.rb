module ApplicationHelper
  def model_id record
    "#{ record.model_name.singular }_#{ record.id }"
  end

  def current_user_is_author_of resource
    user_signed_in? and (current_user.is_author_of resource)
  end
end
