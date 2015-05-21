class API::V1::AnswersController < API::V1::BaseController
  before_action :load_resource, only: :show
  before_action :load_question, only: [:index, :show, :create]

  def index
    respond_with(@answers = @question.answers)
  end

  def show
    respond_with @answer
  end

  def create
    respond_with(@answer = @question.answers.create(resource_params))
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def permit_attributes
    [:body]
  end
end
