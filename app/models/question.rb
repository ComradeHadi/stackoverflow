class Question < ActiveRecord::Base
  include Authorable
  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
end
