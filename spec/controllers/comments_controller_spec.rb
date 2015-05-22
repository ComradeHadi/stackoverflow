require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:question) { create :question }
  let(:answer) { create :answer }
  let(:user) { create :user }
  let(:comment) { create :comment, user: user }
  let(:attributes) { attributes_for :comment }
  let(:invalid_attr) { attributes_for :invalid_comment }

  before { sign_in user }

  models_with_association(:commentable).each do |commentable_name|
    describe "comments on #{commentable_name}" do
      let(:commentable_class) { commentable_name.classify.constantize }
      let(:comment_params) do
        { "#{commentable_name}_id": commentable, commentable: commentable_name, format: :js }
      end
      let(:commentable) { send commentable_name }

      let(:commentable_collection) { commentable_name.underscore.pluralize }
      let(:publish_channel) { "/#{ commentable_collection }/#{ commentable.id }/comments" }

      describe "POST #create" do
        let(:post_comment) { post :create, { comment: attributes }.merge(comment_params) }
        let(:post_invalid) { post :create, { comment: invalid_attr }.merge(comment_params) }

        context 'with valid attributes' do
          it 'assigns @commentable' do
            post_comment
            expect(assigns(:commentable)).to be_a commentable_class
          end

          it 'saves new comment in db' do
            expect { post_comment }.to change { commentable.comments.count }.by(1)
          end

          it 'renders template create' do
            post_comment
            expect(response).to render_template :create
          end

          let(:do_request) { post_comment }
          it_behaves_like "publishable"
        end

        context 'with invalid attributes' do
          it 'does not save new comment in db' do
            expect { post_invalid }.to_not change { commentable.comments.count }
          end

          it 'renders create template' do
            post_invalid
            expect(response).to render_template :create
          end

          let(:do_request) { post_invalid }
          it_behaves_like "not publishable"
        end
      end

      describe "DELETE #destroy" do
        let(:delete_comment) { delete :destroy, id: comment, format: :js }

        before { commentable.comments << comment }

        it 'deletes comment' do
          expect { delete_comment }.to change { commentable.comments.count }.by(-1)
        end

        it 'renders template destroy' do
          delete_comment
          expect(response).to render_template :destroy
        end

        let(:do_request) { delete_comment }
        it_behaves_like "publishable"
      end
    end
  end
end
