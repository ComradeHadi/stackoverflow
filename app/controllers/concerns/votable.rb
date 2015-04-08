module Votable
  extend ActiveSupport::Concern

  LIKE = 1
  DISLIKE = -1

  def liked_by user
    vote_by user
  end

  def downvote_from user
    vote_by user DISLIKE
  end

  def withdraw_vote_by user
    self.votes.where(user_id: user.id).destroy_all if has_vote_by user
  end

  def rating
    self.votes.sum(:like)
  end

  def user_can_vote user
    user_is_author = (self.user_id == user.id)
    (not user_is_author) and (not has_vote_by user)
  end

  def has_vote_by user
    self.votes.exists? user_id: user.id
  end

  # private

  def vote_by user, like = LIKE
    self.votes.create(user_id: user.id, like: like) if user_can_vote user
  end
end

