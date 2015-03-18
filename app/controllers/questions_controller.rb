class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    # show all answers for the question
    @answers = @question.answers
  end

  def new
    @question = Question.new
  end

  def edit
    # check if author
  end

  def create
    @question = Question.new strong_params
    if @question.save
      redirect_to @question, notice: I18n.t('question.created')
    else
      flash[:alert] = 'ERROR: Question not created'
      render :new
    end
  end

  def update
    # check if author
    if @question.update(strong_params)
      redirect_to @question, notice: 'Your question successfully updated.'
    else
      flash[:alert] = 'ERROR: Question not updated'
      render :edit
    end
  end

  def destroy
    # check if author
    @question.destroy
    redirect_to questions_path
  end

  private
  def load_question
    @question = Question.find(params[:id])
  end
  def strong_params
    strong_params = params.require(:question).permit(:title, :body, :user_id)
    strong_params.merge( user_id: current_user.id ) if user_signed_in?
  end
end
