require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:answer_by_another_user) { create(:answer, question: question) }
  let(:attributes) { build_attributes(:answer) }
  let(:invalid_attr) { build_attributes(:invalid_answer) }
  let(:post_answer) { post :create, answer: attributes, question_id: question, format: :js }
  let(:post_invalid) { post :create, answer: invalid_attr, question_id: question, format: :js }
  let(:patch_answer) { patch :update, id: answer, answer: attributes, format: :js }
  let(:patch_invalid_answer) { patch :update, id: answer, answer: invalid_attr, format: :js }
  let(:patch_like) { patch :like, id: answer, format: :js }
  let(:patch_dislike) { patch :dislike, id: answer, format: :js }
  let(:patch_withdraw_vote) { patch :withdraw_vote, id: answer, format: :js }
  let(:user) { create(:user) }
  before { sign_in answer.author }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves new answer in db' do
        expect { post_answer }.to change { question.answers.count }.by(1)
      end

      it 'renders create template' do
        post_answer
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save new answer in db' do
        expect { post_invalid }.to_not change { question.answers.count }
      end

      it 'renders create template' do
        post_invalid
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      before { patch_answer }

      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        expect(answer.reload.body).to eq attributes[:body]
      end

      it 'renders template update' do
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch_invalid_answer }

      it 'does not change answer attributes' do
        expect(answer.reload.body).to_not eq nil
      end

      it 'renders template update' do
        expect(response).to render_template :update
      end
    end

    context 'when unauthorized' do
      it 'does not update answer of another user' do
        patch :update, id: answer_by_another_user, answer: attributes, format: :js
        expect(answer.reload.body).to_not eq attributes[:body]
      end
    end
  end

  describe 'PATCH #accept_as_best' do
    context 'when authorized' do
      before { sign_in question.author }
      before { answer }
      before { answer_by_another_user }
      before { patch :accept_as_best, id: answer, format: :js }

      it 'answer is accepted as best' do
        expect(answer.reload.is_best).to be true
      end

      it 'answer is not the best anymore when another question is accepted as best' do
        patch :accept_as_best, id: answer_by_another_user, format: :js
        expect(answer.reload.is_best).to be false
      end

      it 'renders template accept_as_best' do
        expect(response).to render_template :accept_as_best
      end
    end

    context 'when unauthorized' do
      before { sign_in answer.author }
      before { question }
      before { answer }
      before { answer_by_another_user }
      before { patch :accept_as_best, id: answer, format: :js }

      it 'answer can not be accepted by any user except question author' do
        expect { patch :accept_as_best, id: answer, format: :js }
          .to_not change { answer.reload.is_best }
      end

      it 'renders status 403 forbidden' do
        expect(response).to be_forbidden
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes answer' do
      expect { delete :destroy, id: answer, format: :js }.to change { Answer.count }.by(-1)
    end

    it 'renders template destroy' do
      delete :destroy, id: answer, format: :js
      expect(response).to render_template :destroy
    end
  end

  describe 'PATCH #like' do
    context 'when authorized' do
      before { sign_in user }

      it 'vote for answer increase answer rating' do
        expect { patch_like }.to change { answer.reload.rating }.by(1)
      end

      it 'renders partial votes/update' do
        patch_like
        expect(response).to render_template 'votes/update'
      end
    end

    context 'when unauthorized' do
      before { sign_in answer.author }

      it 'vote does not change rating' do
        expect { patch_like }.to_not change { answer.reload.rating }
      end

      it 'renders status forbidden' do
        patch_like
        expect(response).to be_forbidden
      end
    end
  end

  describe 'PATCH #dislike' do
    context 'when authorized' do
      before { sign_in user }

      it 'vote against answer decrease answer rating' do
        expect { patch_dislike }.to change { answer.reload.rating }.by(-1)
      end

      it 'renders template votes/update' do
        patch_dislike
        expect(response).to render_template 'votes/update'
      end
    end

    context 'when unauthorized' do
      before { sign_in answer.author }

      it 'vote does not change rating' do
        expect { patch_dislike }.to_not change { answer.reload.rating }
      end

      it 'renders status forbidden' do
        patch_dislike
        expect(response).to be_forbidden
      end
    end
  end

  describe 'PATCH #withdraw_vote' do
    context 'when authorized' do
      before { sign_in user }

      it 'withdraw_vote after like returns rating back to zero' do
        patch_like
        patch_withdraw_vote
        expect(answer.reload.rating).to eq 0
      end

      it 'second and subsequent withdraw_vote have no effect on rating' do
        patch_like
        patch_withdraw_vote
        expect { patch_withdraw_vote }.to_not change { answer.reload.rating }
      end

      it 'renders partial votes/update' do
        patch_like
        patch_withdraw_vote
        expect(response).to render_template 'votes/update'
      end
    end

    context 'when unauthorized' do
      before { sign_in answer.author }

      it 'renders status forbidden' do
        patch_withdraw_vote
        expect(response).to be_forbidden
      end
    end
  end
end
