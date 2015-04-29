require "application_responder"

class ApplicationThinController < ApplicationController
  self.responder = ApplicationResponder
  respond_to :html

  private

  def load_resource
    record = resource_model.includes(include_resources).find(params[:id])
    instance_variable_set("@#{ resource_name }", record)
  end

  def check_user_is_author
    return if current_user.author_of? resource
    render status: :forbidden, text: t('failure.not_an_author', scope: resource)
  end

  def attributes
    strong_params = params.require(resource_name.to_sym).permit(*permit_attributes)
    strong_params.merge(user_id: current_user.id) if user_signed_in?
  end

  def publish_changes
    return unless resource.valid?
    private_publish resource
  end

  def private_publish(resource, method = action_name)
    method ||= caller_locations(1, 1)[0].label
    channel = "#{ controller_name }/#{ method }"
    PrivatePub.publish_to "/#{ channel }", render_partial(method, resource)
  end

  def render_partial(template_name, resource)
    resource_name = resource.model_name.element
    view_context.render template_name.to_s, "#{ resource_name }": resource
  end

  def resource_model
    controller_name.classify.constantize
  end

  def resource_name
    resource_model.model_name.element
  end

  def resource
    instance_variable_get("@#{ resource_name }")
  end

  def include_resources
    []
  end

  def permit_attributes
    []
  end
end
