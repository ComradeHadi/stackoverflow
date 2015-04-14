require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  before { sign_in user}

  CommentsController.commentable_resources.each do |commentable|

    describe "comments on #{commentable}" do
      before { @commentable = send commentable }
      let(:commentable_class) { commentable.classify.constantize }
      let(:create_comment) { post :create, comment: attributes_for(:comment), "#{commentable}_id": @commentable, format: :js }
      let(:create_invalid_comment) { post :create, comment: attributes_for(:invalid_comment), "#{commentable}_id": @commentable, format: :js }

      describe "POST #create" do
        context 'with valid attributes' do
          it 'assigns @commentable' do
            create_comment
            expect(assigns(:commentable)).to be_a commentable_class
          end

          it 'saves new comment in db' do
            expect{ create_comment }.to change( @commentable.comments, :count).by(1)
          end

          it 'renders template create' do
            create_comment
            expect(response).to render_template :create
          end
        end

        context 'with invalid attributes' do
          it 'does not save new comment in db' do
            expect{ create_invalid_comment }.to_not change(@commentable.comments, :count)
          end

          it 'renders create template' do
            create_invalid_comment
            expect(response).to render_template :create
          end
        end
      end

      describe "DELETE #destroy" do
	let (:comment) { FactoryGirl.create(:comment, user: user) }
        let (:delete_comment) { delete :destroy, id: comment, format: :js }
        before { @commentable = send commentable }
        before { @commentable.comments << comment }

        it 'deletes comment' do
          expect{ delete_comment }.to change(@commentable.comments, :count).by(-1)
        end

        it 'renders template destroy' do
	  delete_comment
	  expect(response).to render_template :destroy
        end
      end
    end
  end
end
