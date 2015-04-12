require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:answer_by_another_user) { create(:answer, question: question) }
  let(:user) { create(:user) }
  before { sign_in answer.user }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves new answer in db' do
        expect { post :create, answer: build_attributes(:answer), question_id: question, format: :json }.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, answer: build_attributes(:answer), question_id: question, format: :json
        expect(response.header['Content-Type']).to include 'application/json'
      end
    end

    context 'with invalid attributes' do
      it 'does not save new answer in db' do
        expect { post :create, answer: build_attributes(:invalid_answer), question_id: question, format: :json }.to_not change(question.answers, :count)
      end

      it 'renders create template' do
        post :create, answer: build_attributes(:invalid_answer), question_id: question, format: :json
        expect(response.header['Content-Type']).to include 'application/json'
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

    context 'when unauthorized' do
      it 'does not update answer of another user' do
        patch :update, id: answer_by_another_user, answer: { body: 'new body' }, format: :js
        answer.reload
        expect(answer.body).not_to eq 'new body'
      end
    end
  end

  describe 'PATCH #accept_as_best' do
    context 'when authorized' do
      before { sign_in question.user }
      before { answer; answer_by_another_user }
      before { patch :accept_as_best, id: answer, format: :js }

      it 'answer is accepted as best' do
        answer.reload
        expect(answer.is_best).to be true
      end
      it 'answer is not the best anymore when another question is accepted as best' do
        patch :accept_as_best, id: answer_by_another_user, format: :js
        answer.reload
        expect(answer.is_best).to be false
      end
      it 'renders template accept_as_best' do
        expect(response).to render_template :accept_as_best
      end
    end

    context 'when unauthorized' do
      before { sign_in answer.user }
      before { question; answer; answer_by_another_user }
      before { patch :accept_as_best, id: answer, format: :js }

      it 'answer is not accepted by any user except question author' do
        answer.reload
        expect(answer.is_best).to be false
      end

      it 'renders status 403 unauthorized' do
        expect(response).to be_forbidden
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

  describe 'PATCH #like' do
    context 'when authorized' do
      before { sign_in user }
      before { patch :like, id: answer, format: :js }

      it 'vote for answer increase answer rating' do
        answer.reload
        expect( answer.rating ).to eq 1
      end
      it 'renders template votes/update' do
        expect(response).to render_template 'layouts/votes/update'
      end
    end

    context 'when unauthorized' do
      before { patch :like, id: answer, format: :js }

      it 'vote does not change rating' do
        answer.reload
        expect( answer.rating ).to eq 0
      end
      it 'renders status forbidden' do
        expect(response).to be_forbidden
      end
    end
  end

  describe 'PATCH #dislike' do
    context 'when authorized' do
      before { sign_in user }
      before { patch :dislike, id: answer, format: :js }

      it 'vote against answer decrease answer rating' do
        answer.reload
        expect( answer.rating ).to eq -1
      end
      it 'renders template votes/update' do
        expect(response).to render_template 'layouts/votes/update'
      end
    end

    context 'when unauthorized' do
      before { patch :dislike, id: answer, format: :js }

      it 'vote does not change rating' do
        answer.reload
        expect( answer.rating ).to eq 0
      end
      it 'renders status forbidden' do
        expect(response).to be_forbidden
      end
    end
  end

  describe 'PATCH #withdraw_vote' do
    context 'when authorized' do
      before { sign_in user }
      before { patch :like, id: answer, format: :js }
      before { patch :withdraw_vote, id: answer, format: :js }

      it 'withdraw vote returns rating back to zero' do
        question.reload
        expect( question.rating ).to eq 0
      end
      it 'renders partial votes/update' do
        expect(response).to render_template 'layouts/votes/update'
      end
    end

    context 'when unauthorized' do
      before { patch :withdraw_vote, id: answer, format: :js }

      it 'renders status forbidden' do
        expect(response).to be_forbidden
      end
    end
  end

end
