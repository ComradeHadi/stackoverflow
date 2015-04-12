module ApplicationHelper
  def model_id record
    "#{ record.model_name.singular }_#{ record.id }"
  end
end
