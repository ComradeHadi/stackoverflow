class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :authors_only, only: [:edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    # show all answers for the question
    @answers = @question.answers
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit
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
    @question.update(strong_params)
    respond_to do |format|
      format.html { redirect_to @question, notice: I18n.t('question.updated') }
      format.js { render "update" }
    end
  end

  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_path, notice: I18n.t('question.destroyed') }
      format.js { render "destroy", locals: {questions_count: Question.all.count} }
    end
  end

  private
  def load_question
    @question = Question.find(params[:id])
  end
  def authors_only
    unless @question.user_id == current_user.id
      redirect_to @question, alert: I18n.t('question.failure.not_an_author')
    end
  end
  def strong_params
    strong_params = params.require(:question).permit(:title, :body, :user_id, attachments_attributes: [:file])
    strong_params.merge( user_id: current_user.id ) if user_signed_in?
  end
end
