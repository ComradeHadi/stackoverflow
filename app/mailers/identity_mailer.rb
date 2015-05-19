class IdentityMailer < ApplicationMailer
  def confirmation_email(identity)
    @identity = identity
    mail(
      to: identity.email,
      subject: 'Email confirmation required  -- Stackoverflow.local'
    )
  end
end
