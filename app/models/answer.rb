class Answer < ActiveRecord::Base
  include Authorable
  include Attachable
  include Votable
  include Commentable

  default_scope { order(is_best: :desc, created_at: :asc) }

  belongs_to :question

  validates :body, presence: true
  validates :question, presence: true

  after_create :notify_question_subscribers_of_new_answer

  def accept_as_best
    transaction do
      Answer.where(question: question_id, is_best: true).update_all(is_best: false)
      update(is_best: true)
    end
  end

  private

  def notify_question_subscribers_of_new_answer
    question.subscribers.all_except(user).find_each do |subscriber|
      AnswerMailer.notify_of_new_answer(self, subscriber).deliver_later
    end
  end
end
