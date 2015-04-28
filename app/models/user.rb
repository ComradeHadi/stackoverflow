class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :questions, dependent: :restrict_with_exception
  has_many :answers, dependent: :restrict_with_exception
  has_many :votes, dependent: :restrict_with_exception
  has_many :comments, dependent: :restrict_with_exception

  def author_of?(resource)
    resource.user_id == id
  end

  def user_name
    email.split("@")[0]
  end
end
