class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:edit, :update, :destroy]
  before_action :author_only, only: [:edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @question = Question.includes(:attachments, answers: [:attachments]).find(params[:id])
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = Question.new strong_params
    if @question.save
      redirect_to @question, notice: t('question.created')
    else
      render :new, alert: t('question.failure.not_created')
    end
  end

  def update
    @question.update(strong_params)
  end

  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_path, notice: t('question.destroyed') }
      format.js { render "destroy", locals: {questions_count: Question.all.count} }
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def author_only
    if @question.user_id != current_user.id
      render status: :forbidden, text: t('question.failure.not_an_author')
    end
  end

  def strong_params
    strong_params = params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
    strong_params.merge( user_id: current_user.id ) if user_signed_in?
  end
end
