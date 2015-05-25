class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable,
         omniauth_providers: [:facebook, :twitter]

  has_many :questions, dependent: :restrict_with_exception
  has_many :answers, dependent: :restrict_with_exception
  has_many :votes, dependent: :restrict_with_exception
  has_many :comments, dependent: :restrict_with_exception
  has_many :identities, dependent: :delete_all
  has_many :question_subscriptions, dependent: :delete_all

  scope :all_except, ->(user) { where.not(id: user) }

  attr_accessor :no_password

  def self.find_for_auth(auth)
    identity = Identity.find_or_create_for_auth(auth)
    return identity.user if identity.user

    user = find_or_create_or_initialize_by_email auth.info.email
    user.identities << identity
    user
  end

  def self.find_or_create_or_initialize_by_email(email)
    return new unless email.present?
    without_password.find_or_create_by(email: email)
  end

  def self.without_password
    create_with(no_password: true)
  end
  private_class_method :find_or_create_or_initialize_by_email, :without_password

  def password_required?
    super && !no_password
  end

  def author_of?(resource)
    resource.user_id == id
  end

  def user_name
    email.split("@")[0]
  end
end
