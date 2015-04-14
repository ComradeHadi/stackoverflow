class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable_resource, only: :create
  before_action :load_comment, only: :destroy

  mattr_reader :commentable_resources do
    ['question', 'answer']
  end

  def create
    @commentable.comments.create comment_params
  end

  def destroy
    @comment.destroy
  end

  private

  def load_commentable_resource
    commentable_name = commentable_resource_name
    commentable_id = "#{commentable_name}_id"
    @commentable = commentable_name.classify.constantize.find(params[commentable_id])
  end

  def load_comment
    @comment = Comment.find(params[:id])
  end

  def commentable_resource_name
    params.keys.map{|k| k[0..-4]}.select{|k| commentable_resources.include? k}.first
  end

  def comment_params
    strong_params = params.require(:comment).permit(:body)
    strong_params.merge( user_id: current_user.id ) if user_signed_in?
  end
end
