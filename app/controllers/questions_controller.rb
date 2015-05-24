class QuestionsController < ApplicationThinController
  include VotableController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_resource, only: [:show, :update, :destroy]

  after_action :publish_changes, only: [:create, :destroy]

  authorize_resource

  respond_to :html, only: [:index, :show, :new, :create, :destroy]
  respond_to :js, only: [:create, :update, :destroy]

  def index
    respond_with(@questions = Question.all)
  end

  def show
    @subscription = @question.subscription_by current_user || QuestionSubscription.new
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = Question.create(resource_params))
  end

  def update
    @question.update resource_params
    respond_with @question
  end

  def destroy
    @question.destroy
    respond_with @question
  end

  private

  def include_resources
    case action_name
    when 'show'
      [:attachments, :votes, :comments, answers: [:attachments, :votes, :comments]]
    when 'update'
      [:attachments]
    else
      []
    end
  end

  def publish_channel
    "questions"
  end

  def permit_attributes
    [:title, :body, attachments_attributes: [:id, :file, :_destroy]]
  end
end
