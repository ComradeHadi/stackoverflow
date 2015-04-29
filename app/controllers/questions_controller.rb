class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :author_only, only: [:edit, :update, :destroy]

  include VotableController

  respond_to :html, :js

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit
  end

  def create
    @question = Question.new question_params
    if @question.save
      flash[:notice] = t('question.success.create')
      private_publish @question
    end
    respond_with @question
  end

  def update
    @question.update question_params
    respond_with @question
  end

  def destroy
    if @question.destroy
      flash[:notice] = t('question.success.destroy')
      private_publish @question
    end
    respond_with @question
  end

  private

  def load_question
    @question = Question.includes(question_includes).find(params[:id])
  end

  def question_includes
    [:attachments, :votes, :comments, answers: [:attachments, :votes, :comments]]
  end

  def author_only
    return if current_user.author_of? @question
    render status: :forbidden, text: t('question.failure.not_an_author')
  end

  def question_params
    permited = [:title, :body, attachments_attributes: [:id, :file, :_destroy]]
    strong_params = params.require(:question).permit(*permited)
    strong_params.merge(user_id: current_user.id) if user_signed_in?
  end
end
