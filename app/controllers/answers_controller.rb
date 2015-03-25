class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :destroy]
  before_action :load_question, only: [:create]
  before_action :authors_only, only: [:destroy]
  before_action :authorize_set_best, only: [:update]

  def create
    @answer = @question.answers.create(strong_params)
  end

  def update
    @answer.update(strong_params)
    @question = @answer.question
    respond_to do |format|
      format.html { redirect_to question_path(@question), notice: I18n.t('answer.updated') }
      format.js { render "update" }
    end
  end

  def destroy
    @answer.destroy
    respond_to do |format|
      format.html { redirect_to question_path(@answer.question), notice: I18n.t('answer.destroyed') }
      format.js { render "destroy", locals: {answers_count: @answer.question.answers.count} }
    end
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
    end
  end

  def authorize_set_best
    user_is_question_author = (@answer.question.user_id == current_user.id)
    unless (strong_params.has_key?(:is_best) and user_is_question_author)
      authors_only
    end
  end

  def strong_params
    strong_params = params.require(:answer).permit(:title, :body, :question_id, :user_id, :is_best)
    strong_params.merge( user_id: current_user.id ) if user_signed_in?
  end
end
