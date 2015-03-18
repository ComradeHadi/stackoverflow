require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:answers) { create_list(:answer, 2, question: question) }

  describe 'GET #new' do
    before { sign_in question.user }
    before { get :new, question_id: question }

    it 'assigns new answer to @answer' do
      expect(assigns(:answer)).to be_a_new Answer
    end
    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { sign_in question.user }
    before { get :edit, id: answer }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { sign_in question.user }
    context 'with valid attributes' do
      it 'saves new answer in db' do
        expect { post :create, answer: build_attributes(:answer), question_id: question }.to change(question.answers, :count).by(1)
      end
      it 'redirects to question show view vith updated answer' do
        post :create, answer: build_attributes(:answer), question_id: question
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
    context 'with invalid attributes' do
      it 'saves new answer in db' do
        expect { post :create, answer: build_attributes(:invalid_answer), question_id: question }.to_not change(question.answers, :count)
      end
      it 're-renders new view' do
        post :create, answer: build_attributes(:invalid_answer), question_id: question
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in question.user }
    context 'with valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, id: answer, answer: build_attributes(:answer)
        expect(assigns(:answer)).to eq answer
      end
      it 'changes answer attributes' do
        patch :update, id: answer, answer: { body: 'new body' }
        answer.reload
        expect(answer.body).to eq 'new body'
      end
      it 'redirects to question page with updated answer' do
        patch :update, id: answer, answer: { body: 'new body' }
        answer.reload
        expect(response).to redirect_to question_path( answer.question_id )
      end
    end
    context 'with invalid attributes' do
      before { patch :update, id: answer, answer: { body: nil } }
      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).not_to eq nil
      end
      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in question.user }
    before { answer; question }
    it 'deletes answer' do
      expect { delete :destroy, id: answer }.to change(Answer, :count).by(-1)
    end
    it 'redirects to index view' do
      delete :destroy, id: answer
      expect(response).to redirect_to question_answers_path(question)
    end
  end
end
