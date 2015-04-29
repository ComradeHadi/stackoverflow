class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def private_publish(item)
    channel = controller_name
    method = caller_locations(1,1)[0].label
    PrivatePub.publish_to "/#{ channel }", render_partial(method, item)
  end

  def render_partial(template_name, item)
    local_item_name = item.model_name.element
    view_context.render template_name.to_s, "#{local_item_name}": item
  end
end
