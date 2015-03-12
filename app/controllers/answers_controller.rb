class AnswersController < ApplicationController
  before_action :load_answer, only: [:show, :edit, :update, :destroy]

  def index
    @answers = Answer.all
  end

  def show
  end

  def new
    @answer = Answer.new
  end

  def edit
  end

  def create
    @answer = Answer.new(answer_params)
    if @answer.save
      redirect_to @answer
    else
      render :new
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to @answer
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy
    redirect_to answers_path
  end

  private
  def load_answer
    @answer = Answer.find(params[:id])
  end
  def answer_params
    params.require(:answer).permit(:title, :body, :question_id, :user_id)
  end
end
