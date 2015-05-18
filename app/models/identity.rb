class Identity < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, scope: :provider

  def self.find_or_create_for_auth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid.to_s)
  end

  def require_confirmation(email)
    update!(email: email, confirmation_token: SecureRandom.hex)
    IdentityMailer.confirmation_email(self).deliver_now
  end

  def confirm!
    user = User.find_by(email: email)
    return nil unless user

    transaction do
      update!(email: nil, confirmation_token: nil)
      user.identities << self
    end
  end
end
