require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_presence_of :question }

  it_behaves_like "authorable"
  it_behaves_like "commentable"
  it_behaves_like "attachable"
  it_behaves_like "votable"

  it { should belong_to(:question) }

  describe "notify after create" do
    let(:question) { create :question }
    let(:answer_author) { create :user }
    let!(:answer) { build :answer, question: question, user: answer_author }

    before { question.subscribers << create(:user) }
    before { question.subscribers << answer_author }

    it "notifies all question subscribers (except answer author) when new answer is created" do
      question.subscribers.reject {|u| u.id = answer_author.id}.each do |user|
        expect(AnswerMailer).to receive(:notify_of_new_answer)
          .with(answer, user)
          .and_call_original
      end
      answer.save!
    end
  end
end
