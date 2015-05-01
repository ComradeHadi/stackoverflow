class AnswersController < ApplicationThinController
  include VotableController

  before_action :authenticate_user!
  before_action :load_resource, except: :create
  before_action :load_question, only: :create
  before_action :check_user_is_question_author, only: :accept_as_best

  after_action :publish_changes, only: [:create, :destroy]

  respond_to :js

  def create
    respond_with(@answer = @question.answers.create(attributes))
  end

  def update
    @answer.update attributes
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

  def check_user_is_question_author
    return if current_user.author_of? @answer.question
    render status: :forbidden, text: t('question.alert.not_an_author')
  end

  def permit_attributes
    [:body, attachments_attributes: [:file]]
  end

  def publish_channel
    "questions/#{ @answer.question_id }/answers"
  end

  def publish_locals
    { question: @question }
  end
end
