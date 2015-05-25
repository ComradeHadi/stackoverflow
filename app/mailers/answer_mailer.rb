class AnswerMailer < ApplicationMailer
  def notify_of_new_answer(answer, subscriber)
    @answer = answer
    @subscriber = subscriber
    @subscription = answer.question.subscription_by(subscriber)
    mail(
      to: subscriber.email,
      subject: 'New answer has just been posted  -- Stackoverflow.local'
    )
  end
end
