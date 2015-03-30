class FilesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment
  before_action :load_container
  before_action :author_only

  def destroy
    @attachment.destroy
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
    container_name = @attachment.attachable_type
    container_id = @attachment.attachable_id
    container_name.constantize.find(container_id)
  end

  def load_container
    container_name = @attachment.attachable_type
    container_id = @attachment.attachable_id
    @container = container_name.constantize.find(container_id)
  end

  def author_only
    if @container.user_id != current_user.id
      render status: :forbidden, text: I18n.t('file.failure.not_an_author')
    end
  end
end
