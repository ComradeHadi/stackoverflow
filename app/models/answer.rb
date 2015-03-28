class Answer < ActiveRecord::Base
  default_scope { order(is_best: :desc, created_at: :asc) }

  belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachmentable, dependent: :destroy

  validates :body, presence: true
  validates :question, presence: true
  validates :user, presence: true

  accepts_nested_attributes_for :attachments

  def accept_as_best
    Answer.transaction do
      Answer.where(question: question_id, is_best: true).update_all(is_best: false)
      update(is_best: true)
    end
  end
end

