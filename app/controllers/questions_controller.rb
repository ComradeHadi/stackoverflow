class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:edit, :update, :destroy]
  before_action :author_only, only: [:edit, :update, :destroy]

  include VotableController

  def index
    @questions = Question.all
  end

  def show
    @question = Question.includes(question_includes).find(params[:id])
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = Question.new question_params
    if @question.save
      PrivatePub.publish_to "/questions", render_partial(:create)
      redirect_to @question, notice: t('question.success.create')
    else
      render :new
    end
  end

  def update
    @question.update question_params
  end

  def destroy
    @question.destroy
    PrivatePub.publish_to "/questions", render_partial(:destroy)
    respond_to do |format|
      format.html { redirect_to questions_path, notice: t('question.success.destroy') }
      format.js
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def author_only
    return if current_user.author_of? @question
    render status: :forbidden, text: t('question.failure.not_an_author')
  end

  def question_includes
    [:attachments, :votes, :comments, answers: [:attachments, :votes, :comments]]
  end

  def render_partial(template_name)
    view_context.render template_name.to_s, question: @question
  end

  def question_params
    permited = [:title, :body, attachments_attributes: [:id, :file, :_destroy]]
    strong_params = params.require(:question).permit(*permited)
    strong_params.merge(user_id: current_user.id) if user_signed_in?
  end
end
