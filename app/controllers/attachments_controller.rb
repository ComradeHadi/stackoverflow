class AttachmentsController < ApplicationThinController
  before_action :authenticate_user!
  before_action :load_resource
  before_action :check_user_is_author

  respond_to :js

  def destroy
    @attachment.destroy
    respond_with(@attachment)
  end

  private

  def check_user_is_author
    return if current_user.author_of? @attachment.attachable
    render status: :forbidden, text: t('attachment.alert.not_an_author')
  end
end
