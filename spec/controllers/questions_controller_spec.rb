require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create :question }
  let(:attributes) { attributes_for :question }
  let(:invalid_attr) { build_attributes :invalid_question }
  let(:publish_channel) { "/questions" }

  before { sign_in question.author }

  describe 'POST #create' do
    let(:post_question) { post :create, question: attributes }
    let(:post_invalid) { post :create, question: invalid_attr }

    context 'with valid attributes' do
      it 'saves new question in db' do
        expect { post_question }.to change { Question.count }.by(1)
      end

      it 'redirects to show view' do
        post_question
        expect(response).to redirect_to question_path assigns(:question)
      end

      let(:do_request) { post_question }
      it_behaves_like "publishable"
    end

    context 'with invalid attributes' do
      it 'does not save new question in db' do
        expect { post_invalid }.to_not change { Question.count }
      end

      let(:do_request) { post_invalid }
      it_behaves_like "not publishable"
    end
  end

  describe 'PATCH #update' do
    let(:patch_question) { patch :update, id: question, question: attributes, format: :js }
    let(:patch_invalid) { patch :update, id: question, question: invalid_attr, format: :js }

    context 'with valid attributes' do
      it 'changes question attributes' do
        patch_question
        question.reload
        expect(question.title).to eq attributes[:title]
        expect(question.body).to eq attributes[:body]
      end
    end

    context 'with invalid attributes' do
      it 'does not change question attributes' do
        patch_invalid
        question.reload
        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:delete_question) { delete :destroy, id: question }

    it 'deletes question' do
      expect { delete_question }.to change { Question.count }.by(-1)
    end

    it 'redirects to index view' do
      delete_question
      expect(response).to redirect_to questions_path
    end

    let(:do_request) { delete_question }
    it_behaves_like "publishable"
  end

  let(:votable) { question }
  it_behaves_like "Votable Controller"
end
