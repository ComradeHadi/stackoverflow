class Question < ActiveRecord::Base
  include Votable
  include Attachable
  include Commentable

  has_many :answers, dependent: :destroy

  belongs_to :user

  validates :title, :body, presence: true
  validates :user, presence: true
end
