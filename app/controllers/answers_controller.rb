class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, except: [:create]
  before_action :load_question, except: [:destroy]
  before_action :answer_author_only, only: [:update, :destroy]
  before_action :question_author_only, only: [:accept_as_best]

  include VotableController

  def create
    @answer = @question.answers.build answer_params
    @answer.save || render(status: :unprocessable_entity)
  end

  def update
    @answer.update answer_params
  end

  def destroy
    @answer.destroy
  end

  def accept_as_best
    @answer.accept_as_best
  end

  private

  def load_question
    @question =
      if params.key? :question_id
        Question.find(params[:question_id])
      else
        @answer.question
      end
  end

  def load_answer
    @answer = Answer.includes(answer_includes).find(params[:id])
  end

  def answer_author_only
    unless current_user.author_of? @answer
      render status: :forbidden, text: t('answer.failure.not_an_author')
    end
  end

  def question_author_only
    unless current_user.author_of? @answer.question
      render status: :forbidden, text: t('question.failure.not_an_author')
    end
  end

  def answer_includes
    [:attachments, :votes, :comments]
  end

  def answer_params
    strong_params = params.require(:answer).permit(:title, :body, attachments_attributes: [:file])
    strong_params.merge(user_id: current_user.id) if user_signed_in?
  end
end
