require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:answer_by_another_user) { create(:answer) }
  before { sign_in answer.user }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves new answer in db' do
        expect { post :create, answer: build_attributes(:answer), question_id: question, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, answer: build_attributes(:answer), question_id: question, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save new answer in db' do
        expect { post :create, answer: build_attributes(:invalid_answer), question_id: question, format: :js }.to_not change(question.answers, :count)
      end

      it 'renders create template' do
        post :create, answer: build_attributes(:invalid_answer), question_id: question, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, id: answer, answer: build_attributes(:answer), format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, id: answer, answer: { body: 'new body' }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders template update' do
        patch :update, id: answer, answer: { body: 'new body' }, format: :js
        answer.reload
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch :update, id: answer, answer: { body: nil }, format: :js }
      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).not_to eq nil
      end

      it 'renders template update' do
        expect(response).to render_template :update
      end
    end

    context 'unauthorized update' do
      it 'does not update answer of another user' do
        patch :update, id: answer_by_another_user, answer: { body: 'new body' }, format: :js
        answer.reload
        expect(answer.body).not_to eq 'new body'
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes answer' do
      expect{ delete :destroy, id: answer, format: :js }.to change(Answer, :count).by(-1)
    end

    it 'renders template destroy' do
      delete :destroy, id: answer, format: :js
      expect(response).to render_template :destroy
    end
  end
end
