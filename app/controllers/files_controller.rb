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
    if @attachment.attachable.user_id != current_user.id
      render status: :forbidden, text: I18n.t('file.failure.not_an_author')
    end
  end
end
