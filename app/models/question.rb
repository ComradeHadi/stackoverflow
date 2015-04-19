class Question < ActiveRecord::Base
  include Votable
  include Attachable

  has_many :answers, dependent: :destroy
  has_many :comments,    as: :commentable, dependent: :destroy

  belongs_to :user

  validates :title, :body, presence: true
  validates :user, presence: true
end
