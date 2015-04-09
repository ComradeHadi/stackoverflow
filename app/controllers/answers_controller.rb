class AnswersController < ApplicationController
#  include Votable

  before_action :authenticate_user!
  before_action :load_answer, except: [:create]
  before_action :load_question, except: [:destroy]
  before_action :answer_author_only, only: [:update, :destroy]
  before_action :question_author_only, only: [:accept_as_best]

  def create
    @answer = @question.answers.build(strong_params)
    
    respond_to do |format|
      if @answer.save
        format.json
      else
        format.json { render status: :unprocessable_entity }
      end
    end
  end

  def update
    @answer.update(strong_params)
  end

  def destroy
    @answer.destroy
  end

  def accept_as_best
    @answer.accept_as_best
  end

  private

  def load_question
    @question = if params.has_key?(:question_id)
      Question.find(params[:question_id])
    else
      @answer.question
    end
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_author_only
    if @answer.user_id != current_user.id
      render status: :forbidden, text: t('answer.failure.not_an_author')
    end
  end

  def question_author_only
    if @answer.question.user_id != current_user.id
      render status: :forbidden, text: t('question.failure.not_an_author') 
    end
  end

  def strong_params
    strong_params = params.require(:answer).permit(:title, :body, attachments_attributes: [:file])
    strong_params.merge( user_id: current_user.id ) if user_signed_in?
  end
end
