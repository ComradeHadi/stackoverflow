class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy

  belongs_to :user

  validates :title, :body, presence: true
  validates :user, presence: true
end
