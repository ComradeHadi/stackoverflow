module VotableController
  extend ActiveSupport::Concern

  included do
    before_action :load_votable_resource, only: [:like, :dislike, :withdraw_vote]
    before_action :check_user_can_vote,   only: [:like, :dislike, :withdraw_vote]

    helper_method :user_can_vote_for
  end

  def like
    @votable.liked_by current_user unless @votable.has_vote_by current_user
    render_votes
  end

  def dislike
    @votable.disliked_by current_user unless @votable.has_vote_by current_user
    render_votes
  end

  def withdraw_vote
    @votable.withdraw_vote_by current_user if @votable.has_vote_by current_user
    render_votes
  end

  def user_can_vote_for votable
    if user_signed_in?
      votable.user_id != current_user.id
    end
  end

  private


  def load_votable_resource
    @votable = controller_name.classify.constantize.find(params[:id])
  end

  def check_user_can_vote
    unless user_can_vote_for @votable
      render status: :forbidden, text: t('vote.failure.not_allowed_to_vote')
    end
  end

  def render_votes
    render 'layouts/votes/update'
  end
end
