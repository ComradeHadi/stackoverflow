class Answer < ActiveRecord::Base
  before_save :ensure_single_best_answer, if: :is_best

  default_scope { order(:created_at) }

  belongs_to :question
  belongs_to :user

  validates :body, presence: true
  validates :question, presence: true
  validates :user, presence: true

  def ensure_single_best_answer
    Answer.where(question: question_id, is_best: true).update_all(is_best: false)
  end
end

