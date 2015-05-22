require 'rails_helper'

RSpec.describe 'Question API' do
  describe 'GET #index' do
    let(:api_path) { api_v1_questions_path }

    it_behaves_like "API authenticatable"

    context 'authorized' do
      let(:access_token) { create :access_token }
      let!(:questions) { create_list(:question, 2, :with_files, files_count: 3) }
      let(:question) { questions.first }
      let!(:answers) { create_list :answer, 2, question: question }
      let!(:comments) { create_list :comment, 3, commentable: question }
      let!(:attachments) { question.attachments }

      let(:attributes) { attributes_for :question }
      let(:params) { { question: attributes, format: :json, access_token: access_token.token } }
      let(:post_create) { post api_v1_questions_path, params }

      before { get api_v1_questions_path, format: :json, access_token: access_token.token }

      it_behaves_like "response ok"

      it 'returns list of questions' do
        expect(response.body).to have_json_size(questions.size).at_path("questions")
      end

      permitted_attributes = [
        :id, :title, :body, :user_id, :created_at, :updated_at
      ]
      permitted_attributes.each do |attr|
        it "contains #{ attr }" do
          question_attr = question.send(attr.to_sym).to_json
          path = "questions/0/#{ attr }"
          expect(response.body).to be_json_eql(question_attr).at_path(path)
        end
      end

      context "nested answers" do
        it "includes answers" do
          path = "questions/0/answers"
          expect(response.body).to have_json_size(question.answers.size).at_path(path)
        end

        permitted_attributes = [
          :id, :body, :user_id, :created_at, :updated_at
        ]
        permitted_attributes.each do |attr|
          it "contains #{ attr }" do
            path = "questions/0/answers/0/#{ attr }"
            answer_attr = question.answers.first.send(attr.to_sym).to_json
            expect(response.body).to be_json_eql(answer_attr).at_path(path)
          end
        end
      end

      context "nested comments" do
        it "includes comments" do
          path = "questions/0/comments"
          expect(response.body).to have_json_size(question.comments.size).at_path(path)
        end

        permitted_attributes = [
          :id, :body, :user_id, :created_at, :updated_at
        ]
        permitted_attributes.each do |attr|
          it "comment contains #{ attr }" do
            path = "questions/0/comments/0/#{ attr }"
            comment_attr = question.comments.first.send(attr.to_sym).to_json
            expect(response.body).to be_json_eql(comment_attr).at_path(path)
          end
        end
      end

      context "nested attachments" do
        it "includes attachments" do
          path = "questions/0/attachments"
          expect(response.body).to have_json_size(attachments.size).at_path(path)
        end

        it "attachment contains url" do
          path = "questions/0/attachments/0/url"
          attachment_attr = question.attachments.first.file.url.to_json
          expect(response.body).to be_json_eql(attachment_attr).at_path(path)
        end
      end

      context 'create new question' do
        it_behaves_like "creatable"

        it 'saves new question in db' do
          expect { post_create }.to change { Question.count }.by(1)
        end
      end
    end
  end
end
