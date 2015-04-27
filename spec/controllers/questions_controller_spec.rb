require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:attributes) { attributes_for(:question) }
  let(:invalid_attributes) { build_attributes(:invalid_question) }
  let(:questions) { create_list(:question, 2) }
  let(:post_question) { post :create, question: attributes }
  let(:post_invalid_question) { post :create, question: invalid_attributes }
  let(:patch_question) { patch :update, id: question, question: attributes, format: :js }
  let(:patch_invalid_question) { patch :update, id: question, question: invalid_attributes, format: :js }
  let(:patch_like) { patch :like, id: question, format: :js }
  let(:patch_dislike) { patch :dislike, id: question, format: :js }
  let(:patch_withdraw_vote) { patch :withdraw_vote, id: question, format: :js }
  let(:user) { create(:user) }

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
    before { sign_in question.author }
    before { get :new }

    it 'assigns new question to @question' do
      expect(assigns(:question)).to be_a_new Question
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
  end

  describe 'POST #create' do
    before { sign_in question.author }

    context 'with valid attributes' do
      it 'saves new question in db' do
        expect { post_question }.to change{ Question.count }.by(1)
      end

      it 'redirects to show view' do
        post_question
        expect(response).to redirect_to question_path assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save new question in db' do
        expect { post_invalid_question }.to_not change{ Question.count }
      end

      it 'renders new view' do
        post_invalid_question
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in question.author }
    before { patch_question }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        question.reload
        expect(question.title).to eq attributes[:title]
        expect(question.body).to eq attributes[:body]
      end

      it 'renders update template' do
        question.reload
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch_invalid_question }

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in question.author }

    it 'deletes question' do
      expect { delete :destroy, id: question }.to change{ Question.count }.by(-1)
    end

    it 'redirects to index view' do
      delete :destroy, id: question
      expect(response).to redirect_to questions_path
    end
  end

  describe 'PATCH #like' do
    context 'when authorized' do
      before { sign_in user }

      it 'vote for question increase question rating' do
        expect{ patch_like }.to change{ question.reload.rating }.by(1)
      end

      it 'renders partial votes/update' do
        patch_like
        expect(response).to render_template 'votes/update'
      end
    end

    context 'when unauthorized' do
      before { sign_in question.author }

      it 'vote does not change rating' do
        expect{ patch_like }.to_not change{ question.reload.rating }
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

      it 'vote against question decrease question rating' do
        expect{ patch_dislike }.to change{ question.reload.rating }.by(-1)
      end

      it 'renders partial votes/update' do
        patch_dislike
        expect(response).to render_template 'votes/update'
      end
    end

    context 'when unauthorized' do
      before { sign_in question.author }

      it 'vote does not change rating' do
        expect{ patch_dislike }.to_not change{ question.reload.rating }
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

      it 'withdraw vote after like returns rating back to zero' do
        patch_like
        patch_withdraw_vote
        expect(question.reload.rating).to eq 0
      end

      it 'second and subsequent withdraw_vote have no effect on rating' do
        patch_like
        patch_withdraw_vote
        expect{ patch_withdraw_vote }.to_not change{ question.reload.rating }
      end

      it 'renders partial votes/update' do
        patch_like
        patch_withdraw_vote
        expect(response).to render_template 'votes/update'
      end
    end

    context 'when unauthorized' do
      before { sign_in question.author }

      it 'renders status forbidden' do
        patch_withdraw_vote
        expect(response).to be_forbidden
      end
    end
  end
end
