require 'rails_helper'

RSpec.describe 'Answers API' do
  describe 'GET #index' do
    context 'unauthorized' do
      let!(:question) { create :question }

      it 'returns status unauthorized if access_token is not provided' do
        get api_v1_question_answers_path(question), format: :json
        expect(response).to be_unauthorized
      end

      it 'returns status unauthorized if access_token is invalid' do
        get api_v1_question_answers_path(question), format: :json, access_token: SecureRandom.hex
        expect(response).to be_unauthorized
      end
    end

    context 'authorized' do
      let(:path_resource) { "answers/0" }
      let(:access_token) { create :access_token }
      let(:question) { create :question }
      let(:answer) { create(:answer, :with_files, files_count: 3, question: question) }
      let(:answer2) { create :answer, question: question }
      let!(:answers) { [answer, answer2] }
      let!(:comments) { create_list :comment, 3, commentable: resource }
      let!(:resource) { answer }
      let!(:attachments) { resource.attachments }

      let(:attributes) { attributes_for :answer }
      let(:params) { { answer: attributes, format: :json, access_token: access_token.token } }
      let(:post_create) { post api_v1_question_answers_path(question), params }

      before do
        get api_v1_question_answers_path(question), format: :json, access_token: access_token.token
      end

      it 'returns status ok' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(answers.size).at_path("answers")
      end

      resource_attributes(:answer).each do |attr|
        it "contains #{ attr }" do
          resource_attr = resource.send(attr.to_sym).to_json
          path = "#{ path_resource }/#{ attr }"
          expect(response.body).to be_json_eql(resource_attr).at_path(path)
        end
      end

      resource_associations(:answer).each do |association|
        context "#{ association }" do
          it "includes #{ association }" do
            path = "#{ path_resource }/#{ association }"
            expect(response.body).to have_json_size(resource.send(association).count).at_path(path)
          end

          resource_attributes(association).each do |attr|
            it "#{ association.to_s.singularize } contains #{ attr }" do
              path = "#{ path_resource }/#{ association }/0/#{ attr }"
              association_attr = send(association).first.send(attr.to_sym).to_json
              expect(response.body).to be_json_eql(association_attr).at_path(path)
            end
          end
        end
      end

      context 'create new answer' do
        it 'returns status created' do
          post_create
          expect(response).to be_created
        end

        it 'saves new answer in db' do
          expect { post_create }.to change { question.answers.count }.by(1)
        end
      end
    end
  end
end
