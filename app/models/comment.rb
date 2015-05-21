class Comment < ActiveRecord::Base
  include Authorable

  default_scope { order(created_at: :asc) }

  belongs_to :commentable, polymorphic: true

  validates :body, presence: true
end
