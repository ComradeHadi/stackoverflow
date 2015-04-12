class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id, :like, :votable_id, :votable_type, presence: true
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
  validates :like, inclusion: [-1, 1]
end
