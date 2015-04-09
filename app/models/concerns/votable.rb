module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  LIKE = 1
  DISLIKE = -1

  def liked_by user
    vote_by user, LIKE
  end

  def downvote_by user
    vote_by user, DISLIKE
  end

  def vote_by user, like = LIKE
    votes.create(user: user, like: like) if user_can_vote? user
  end

  def withdraw_vote_by user
    votes.where(user: user).delete_all if user_can_withdraw_vote? user
  end

  def user_can_vote? user
    user_is_author = (user_id == user.id)
    (not user_is_author) and (not has_vote_by user)
  end

  def user_can_withdraw_vote? user
    has_vote_by user
  end

  def has_vote_by user
    votes.where(user: user).exists?
  end

  def rating
    votes.sum :like
  end
end
