class QuestionsController < ApplicationThinController
  include VotableController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_resource, only: [:show, :update, :destroy]
  before_action :check_user_is_author, only: [:update, :destroy]

  after_action :publish_changes, only: [:create, :destroy]

  respond_to :html, only: [:index, :show, :new, :create, :destroy]
  respond_to :js, only: [:create, :update, :destroy]

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = Question.create(attributes))
  end

  def update
    @question.update attributes
    respond_with @question
  end

  def destroy
    @question.destroy
    respond_with @question
  end

  private

  def include_resources
    [:attachments, :votes, :comments, answers: [:attachments, :votes, :comments]]
  end

  def publish_channel
    "questions"
  end

  def permit_attributes
    [:title, :body, attachments_attributes: [:file]]
  end
end
