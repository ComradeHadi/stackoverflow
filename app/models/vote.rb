class Vote < ActiveRecord::Base
  include Authorable

  belongs_to :votable, polymorphic: true

  validates :like, :votable_id, :votable_type, presence: true
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
  validates :like, inclusion: [Votable::LIKE, Votable::DISLIKE]
end
