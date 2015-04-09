class Question < ActiveRecord::Base
  include Votable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy

#has_many :votes, as: :votable, dependent: :destroy

  belongs_to :user

  validates :title, :body, presence: true
  validates :user, presence: true

  accepts_nested_attributes_for :attachments
end
