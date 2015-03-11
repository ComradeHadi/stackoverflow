class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, presence: true
  # validates :question, presence: true
  # validates :user, presence: true
end
