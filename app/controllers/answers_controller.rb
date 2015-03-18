class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:edit, :update, :destroy]
  before_action :load_question, only: [:new, :create]
  before_action :authors_only, only: [:edit, :update, :destroy]

  def new
    @answer = @question.answers.new
  end

  def edit
  end

  def create
    @answer = @question.answers.new(strong_params)
    if @answer.save
      redirect_to question_path(@question), notice: I18n.t('answer.created')
    else
      flash[:alert] = I18n.t('answer.failure.not_created')
      render :new
    end
  end

  def update
    if @answer.update(strong_params)
      redirect_to question_path(@answer.question_id), notice: I18n.t('answer.updated')
    else
      flash[:alert] = I18n.t('answer.failure.not_updated')
      render :edit
    end
  end

  def destroy
    @answer.destroy
    redirect_to question_path(@answer.question), notice: I18n.t('answer.destroyed')
  end

  private
  def load_question
    @question = Question.find(params[:question_id])
  end
  def load_answer
    @answer = Answer.find(params[:id])
  end
  def authors_only
    unless @answer.user_id == current_user.id
      redirect_to @answer.question, alert: I18n.t('answer.failure.not_an_author')
      return
    end
  end
  def strong_params
    strong_params = params.require(:answer).permit(:title, :body, :question_id, :user_id)
    strong_params.merge( user_id: current_user.id ) if user_signed_in?
  end
end
