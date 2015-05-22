require 'rails_helper'

RSpec.describe 'Answers API' do
  describe 'GET #index' do
    let!(:question) { create :question }
    let(:api_path) { api_v1_question_answers_path(question) }

    it_behaves_like "API authenticatable"

    context 'authorized' do
      let(:access_token) { create :access_token }
      let(:question) { create :question }
      let(:answer) { create(:answer, :with_files, files_count: 3, question: question) }
      let(:answer2) { create :answer, question: question }
      let!(:answers) { [answer, answer2] }
      let!(:comments) { create_list :comment, 2, commentable: answer }
      let!(:attachments) { answer.attachments }

      let(:attributes) { attributes_for :answer }
      let(:token) { access_token.token }
      let(:params) { { answer: attributes, format: :json, access_token: token } }
      let(:post_create) { post api_v1_question_answers_path(question), params }

      before do
        get api_v1_question_answers_path(question), format: :json, access_token: token
      end

      it_behaves_like "response ok"

      it 'returns list of answers' do
        expect(response.body).to have_json_size(answers.size).at_path("answers")
      end

      permitted_attributes = [
        :id, :body, :user_id, :created_at, :updated_at
      ]
      permitted_attributes.each do |attr|
        it "contains #{ attr }" do
          answer_attr = answer.send(attr.to_sym).to_json
          path = "answers/0/#{ attr }"
          expect(response.body).to be_json_eql(answer_attr).at_path(path)
        end
      end

      context "nested comments" do
        it "includes comments" do
          path = "answers/0/comments"
          expect(response.body).to have_json_size(answer.comments.size).at_path(path)
        end

        permitted_attributes = [
          :id, :body, :user_id, :created_at, :updated_at
        ]
        permitted_attributes.each do |attr|
          it "comment contains #{ attr }" do
            path = "answers/0/comments/0/#{ attr }"
            comment_attr = comments.first.send(attr.to_sym).to_json
            expect(response.body).to be_json_eql(comment_attr).at_path(path)
          end
        end
      end

      context "nested attachments" do
        it "includes attachments" do
          path = "answers/0/attachments"
          expect(response.body).to have_json_size(attachments.size).at_path(path)
        end

        it "attachment contains url" do
          path = "answers/0/attachments/0/url"
          expect(response.body).to be_json_eql(attachments.first.file.url.to_json).at_path(path)
        end
      end

      context 'create new answer' do
        it_behaves_like "creatable"

        it 'saves new answer in db' do
          expect { post_create }.to change { question.answers.size }.by(1)
        end
      end
    end
  end
end
