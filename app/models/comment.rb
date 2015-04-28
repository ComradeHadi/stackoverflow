class Comment < ActiveRecord::Base
  include Authorable

  belongs_to :commentable, polymorphic: true

  validates :body, presence: true
end
