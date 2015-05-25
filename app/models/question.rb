class Question < ActiveRecord::Base
  include Authorable
  include Attachable
  include Votable
  include Commentable

  scope :created_yesterday, -> { where(created_at: Time.zone.now.yesterday.all_day) }

  has_many :answers, dependent: :destroy

  has_many :subscriptions, \
           foreign_key: 'question_id', \
           class_name: 'QuestionSubscription', \
           dependent: :delete_all

  has_many :subscribers, \
           through: :subscriptions, \
           source: :user

  validates :title, :body, presence: true

  after_create :subscribe_author

  def subscription_by(user)
    subscriptions.find_by(user: user)
  end

  private

  def subscribe_author
    subscribers << author
  end
end
