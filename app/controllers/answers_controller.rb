class AnswersController < ApplicationThinController
  include VotableController

  before_action :authenticate_user!
  before_action :load_resource, except: :create
  before_action :load_question, only: :create

  after_action :publish_changes, only: [:create, :destroy]

  authorize_resource

  respond_to :js

  def create
    respond_with(@answer = @question.answers.create(resource_params))
  end

  def update
    @answer.update resource_params
    respond_with @answer
  end

  def destroy
    @answer.destroy
    respond_with @answer
  end

  def accept_as_best
    @answer.accept_as_best
    respond_with @answer
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def permit_attributes
    [:body, attachments_attributes: [:id, :file, :_destroy]]
  end

  def publish_channel
    "questions/#{ @answer.question_id }/answers"
  end

  def publish_locals
    { question: @question }
  end
end
