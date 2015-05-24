class DigestMailer < ApplicationMailer
  def dayly_digest(user)
    @user = user
    @questions = Question.created_yesterday
    mail(
      to: user.email, 
      subject: 'All the questions asked yesterday  -- Stackoverflow.local'
    )
  end
end
