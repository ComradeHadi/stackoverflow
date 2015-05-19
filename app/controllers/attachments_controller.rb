class AttachmentsController < ApplicationThinController
  before_action :authenticate_user!
  before_action :load_resource

  authorize_resource

  respond_to :js

  def destroy
    @attachment.destroy
    respond_with(@attachment)
  end
end
