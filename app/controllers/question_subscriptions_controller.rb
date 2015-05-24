class QuestionSubscriptionsController < ApplicationThinController
  before_action :authenticate_user!
  before_action :load_resource, only: :destroy
  before_action :load_question, only: :create

  authorize_resource

  respond_to :js

  def create
    @question_subscription = @question.subscriptions.create(user: current_user)
    respond_with @question_subscription
  end

  def destroy
    @question_subscription.destroy
    respond_with @question_subscription
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end
end
