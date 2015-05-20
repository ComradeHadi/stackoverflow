module VotableController
  extend ActiveSupport::Concern

  included do
    before_action :load_votable_resource, only: [:like, :dislike, :withdraw_vote]
  end

  def like
    authorize! :vote, @votable
    @votable.liked_by current_user
    render_votes
  end

  def dislike
    authorize! :vote, @votable
    @votable.disliked_by current_user
    render_votes
  end

  def withdraw_vote
    authorize! :withdraw_vote, @votable
    @votable.withdraw_vote_by current_user
    render_votes
  end

  private

  def load_votable_resource
    @votable = controller_name.classify.constantize.find(params[:id])
  end

  def render_votes
    render 'votes/update'
  end
end
