require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:answers) { create_list(:answer, 2) }

  describe 'GET #index' do
    before { get :index }

    it 'populates answers array' do
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: answer }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns new answer to @answer' do
      expect(assigns(:answer)).to be_a_new Answer
    end
    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, id: answer }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves new answer in db' do
        expect { post :create, answer: attributes_for(:answer) }.to change(Answer, :count).by(1)
      end
      it 'redirects to show view' do
        post :create, answer: attributes_for(:answer)
        expect(response).to redirect_to answer_path(assigns(:answer))
      end
    end
    context 'with invalid attributes' do
      it 'saves new answer in db' do
        expect { post :create, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end
      it 're-renders new view' do
        post :create, answer: attributes_for(:invalid_answer)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, id: answer, answer: attributes_for(:answer)
        expect(assigns(:answer)).to eq answer
      end
      it 'changes answer attributes' do
        patch :update, id: answer, answer: { body: 'new body' }
        answer.reload
        expect(answer.body).to eq 'new body'
      end
      it 'redirects to updated answer' do
        patch :update, id: answer, answer: { body: 'new body' }
        answer.reload
        expect(response).to redirect_to answer
      end
    end
    context 'with invalid attributes' do
      before { patch :update, id: answer, answer: { body: nil } }

      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to eq 'MyText'
      end
      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before { answer }
    it 'deletes answer' do
      expect { delete :destroy, id: answer }.to change(Answer, :count).by(-1)
    end
    it 'redirects to index view' do
      delete :destroy, id: answer
      expect(response).to redirect_to answers_path
    end
  end
end
