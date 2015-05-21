class API::V1::QuestionsController < API::V1::BaseController
  before_action :load_resource, only: :show

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def create
    respond_with(@question = Question.create(resource_params))
  end

  private

  def permit_attributes
    [:title, :body]
  end
end
