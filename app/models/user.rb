class User < ActiveRecord::Base
  has_many :questions, dependent: :restrict_with_exception
  has_many :answers, dependent: :restrict_with_exception
end
