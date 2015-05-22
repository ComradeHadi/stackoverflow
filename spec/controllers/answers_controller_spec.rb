require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create :question }
  let(:answer) { create :answer, question: question }
  let(:answer_by_another_user) { create :answer, question: question }
  let(:attributes) { build_attributes :answer }
  let(:invalid_attr) { build_attributes :invalid_answer }
  let(:post_answer) { post :create, answer: attributes, question_id: question, format: :js }
  let(:post_invalid) { post :create, answer: invalid_attr, question_id: question, format: :js }
  let(:patch_answer) { patch :update, id: answer, answer: attributes, format: :js }
  let(:patch_invalid_answer) { patch :update, id: answer, answer: invalid_attr, format: :js }
  let(:publish_channel) { "/questions/#{ question.id }/answers" }

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

      let(:do_request) { post_answer }
      it_behaves_like "publishable"
    end

    context 'with invalid attributes' do
      it 'does not save new answer in db' do
        expect { post_invalid }.to_not change { question.answers.count }
      end

      let(:do_request) { post_invalid }
      it_behaves_like "not publishable"
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
    let(:delete_answer) { delete :destroy, id: answer, format: :js }

    it 'deletes answer' do
      expect { delete_answer }.to change { Answer.count }.by(-1)
    end

    it 'renders template destroy' do
      delete_answer
      expect(response).to render_template :destroy
    end

    let(:do_request) { delete_answer }
    it_behaves_like "publishable"
  end

  let(:votable) { answer }
  it_behaves_like "Votable Controller"
end
