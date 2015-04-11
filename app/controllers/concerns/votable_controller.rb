module VotableController
  extend ActiveSupport::Concern

  included do
    before_action :load_votable_resource, only: [:like, :dislike, :withdraw_vote]
    before_action :check_can_vote,        only: [:like, :dislike, :withdraw_vote]
    after_action  :render_votes,          only: [:like, :dislike, :withdraw_vote]

    helper_method :votable_model_id, :user_can_vote?
  end

  def like
    @votable.liked_by current_user unless @votable.has_vote_by current_user
  end

  def dislike
    @votable.disliked_by current_user unless @votable.has_vote_by current_user
  end

  def withdraw_vote
    @votable.withdraw_vote_by current_user if @votable.has_vote_by current_user
  end

  def votable_model_id
   "#{ votable.model_name.singular }_#{votable.id}"
  end

  def user_can_vote?
    if user_signed_in?
      @votable.user_id != current_user.id
    end
  end


  private


  def load_votable_resource
    @votable = controller_name.classify.constantize.find(params[:id])
  end

  def check_can_vote
    unless user_can_vote?
      render status: :forbidden, text: t('vote.failure.not_allowed_to_vote')
    end
  end

  def render_votes
    render 'layouts/votes/show', votable: @votable
  end
end
