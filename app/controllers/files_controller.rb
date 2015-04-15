class FilesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment
  before_action :author_only

  def destroy
    @attachment.destroy
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end

  def author_only
    unless current_user.is_author_of @attachment.attachable
      render status: :forbidden, text: t('file.failure.not_an_author')
    end
  end
end
