require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:questions) { create_list(:question, 2) }

  describe 'GET #index' do
    before { get :index }

    it 'populates questions array' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { sign_in question.user }
    before { get :new }

    it 'assigns new question to @question' do
      expect(assigns(:question)).to be_a_new Question
    end

    it 'builds new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new Attachment
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { sign_in question.user }
    before { get :edit, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { sign_in question.user }
    context 'with valid attributes' do
      it 'saves new question in db' do
        expect { post :create, question: build_attributes(:question) }.to change(Question, :count).by(1)
      end
      it 'redirects to show view' do
        post :create, question: build_attributes(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
    context 'with invalid attributes' do
      it 'saves new question in db' do
        expect { post :create, question: build_attributes(:invalid_question) }.to_not change(Question, :count)
      end
      it 're-renders new view' do
        post :create, question: build_attributes(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in question.user }
    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(assigns(:question)).to eq question
      end
      it 'changes question attributes' do
        patch :update, id: question, question: { title: 'new title', body: 'new body' }
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end
      it 'redirects to updated question' do
        patch :update, id: question, question: { title: 'new title', body: 'new body' }
        question.reload
        expect(response).to redirect_to question
      end
    end
    context 'with invalid attributes' do
      before { patch :update, id: question, question: { title: 'new title', body: nil } }

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end
      it 're-renders edit view' do
        expect(response).to redirect_to question
      end
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in question.user }
    it 'deletes question' do
      expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
    end
    it 'redirects to index view' do
      delete :destroy, id: question
      expect(response).to redirect_to questions_path
    end
  end
end
