class Answer < ActiveRecord::Base
  default_scope { order(is_best: :desc, created_at: :asc) }

  belongs_to :question
  belongs_to :user

  validates :body, presence: true
  validates :question, presence: true
  validates :user, presence: true

  def accept_as_best
    Answer.transaction do
      Answer.where(question: question_id, is_best: true).update_all(is_best: false)
      update(is_best: true)
    end
  end
end

