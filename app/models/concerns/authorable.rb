module Authorable
  extend ActiveSupport::Concern

  included do
    belongs_to :user
    validates :user, presence: true
    alias_attribute :author, :user
  end
end
