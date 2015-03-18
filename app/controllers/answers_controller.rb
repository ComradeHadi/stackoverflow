class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_answer, only: [:show, :edit, :update, :destroy]
  before_action :load_question, only: [:index, :new, :create]

  def index
    #TODO: убрать answers#index
    #      список вопросов отображать в questions#show
    @answers = @question.answers
  end

  def show
    #TODO: убрать answers#show
    # не показывать ответ на отдельной странице
    # только список ответов на вопрос на странице указанного вопроса
  end

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
    redirect_to question_answers_path(@answer.question)
  end

  private
  def load_question
    @question = Question.find(params[:question_id])
  end
  def load_answer
    @answer = Answer.find(params[:id])
  end
  def strong_params
    strong_params = params.require(:answer).permit(:title, :body, :question_id, :user_id)
    strong_params.merge( user_id: current_user.id ) if user_signed_in?
  end
end
