class Question < ActiveRecord::Base
  include Votable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable,  dependent: :destroy
  has_many :comments,    as: :commentable, dependent: :destroy

  belongs_to :user

  validates :title, :body, presence: true
  validates :user, presence: true

  accepts_nested_attributes_for :attachments
end
