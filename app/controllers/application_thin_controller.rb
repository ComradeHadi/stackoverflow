require "application_responder"

class ApplicationThinController < ApplicationController
  self.responder = ApplicationResponder
  respond_to :html

  private

  # before_action :load_resource, only: [:show, :update, :destroy, ...]
  # :include_resources may be overriden in controller
  def load_resource
    record = resource_model.includes(include_resources).find(params[:id])
    instance_variable_set("@#{ resource_name }", record)
  end

  # before_action :check_user_is_author, only: [:update, :destroy, ...]
  def check_user_is_author
    return if current_user.author_of? resource
    render status: :forbidden, text: t('alert.not_an_author', scope: resource)
  end

  # :permit_attributes must be overriden in controller
  def attributes
    strong_params = params.require(resource_name.to_sym).permit(*permit_attributes)
    strong_params.merge(user_id: current_user.id) if user_signed_in?
  end

  # after_action :publish_changes, only: [:create, :destroy]
  def publish_changes
    return unless resource.valid?
    private_publish resource
  end

  def private_publish(resource, method_name = action_name)
    channel = publish_channel || "#{ controller_name }/#{ resource.id }"
    PrivatePub.publish_to "/#{ channel }", render_publish_template(method_name, resource)
  end

  # :publish_locals may be overriden in controller
  def render_publish_template(method_name, resource)
    publish_template = "#{ controller_name }/publish_#{ method_name }"
    locals = { "#{ resource_name }": resource }.merge(publish_locals)
    render_to_string partial: publish_template, locals: locals, formats: [:js]
  end

  def resource_model
    @resource_model ||= controller_name.classify.constantize
  end

  def resource_name
    @resource_name ||= controller_name.singularize
  end

  def resource
    @resource ||= instance_variable_get("@#{ resource_name }")
  end

  def include_resources
    []
  end

  def permit_attributes
    []
  end

  def publish_channel
    nil
  end

  def publish_locals
    {}
  end
end
