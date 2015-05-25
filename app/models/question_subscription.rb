class QuestionSubscription < ActiveRecord::Base
  include Authorable

  belongs_to :question
  validates :question, presence: true

  validates :user_id, uniqueness: { scope: :question_id }
end
