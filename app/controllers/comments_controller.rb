class CommentsController < ApplicationThinController
  before_action :authenticate_user!
  before_action :load_commentable, only: :create
  before_action :load_resource, only: :destroy

  after_action :publish_changes, only: [:create, :destroy]

  respond_to :js, only: [:create, :destroy]

  def create
    respond_with(@comment = @commentable.comments.create(attributes))
  end

  def destroy
    @comment.destroy
    respond_with @comment
  end

  private

  def load_commentable
    @commentable = commentable_klass.find params["#{commentable_name}_id"]
  end

  def commentable_name
    params[:commentable]
  end

  def commentable_klass
    commentable_name.classify.constantize
  end

  def permit_attributes
    [:body, :commentable]
  end

  def publish_channel
    commentable_collection = @comment.commentable_type.underscore.pluralize
    commentable_id = @comment.commentable_id
    "#{ commentable_collection }/#{ commentable_id }/comments"
  end

  def publish_locals
    { commentable: @commentable }
  end
end
