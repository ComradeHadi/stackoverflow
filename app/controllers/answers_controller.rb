class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, except: [:create]
  before_action :load_question, only: [:create]
  before_action :answer_author_only, only: [:update, :destroy]
  before_action :question_author_only, only: [:accept_as_best]

  def create
    @answer = @question.answers.create(strong_params)
  end

  def update
    @answer.update(strong_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy
  end

  def accept_as_best
    @answer.accept_as_best
    @question = @answer.question
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_author_only
    if @answer.user_id != current_user.id
      render status: 403, text: I18n.t('answer.failure.not_an_author')
    end
  end

  def question_author_only
    if @answer.question.user_id != current_user.id
      render status: 403, text: I18n.t('question.failure.not_an_author') 
    end
  end

  def strong_params
    strong_params = params.require(:answer).permit(:title, :body, :question_id, :user_id)
    strong_params.merge( user_id: current_user.id ) if user_signed_in?
  end
end
