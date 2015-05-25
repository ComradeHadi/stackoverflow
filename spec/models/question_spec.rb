require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it_behaves_like "authorable"
  it_behaves_like "commentable"
  it_behaves_like "attachable"
  it_behaves_like "votable"

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:delete_all) }
  it { should have_many(:subscribers) }

  describe "question author is subscribed to question automaticaly" do
    let!(:question) { create :question }

    it "subscibes question author" do
      expect(question.subscribers).to include(question.author)
    end
  end

  describe ".subscription_by" do
    let!(:subscription) { create :question_subscription }
    let(:question) { subscription.question }

    it "returns subscription by given user" do
      expect(question.subscription_by subscription.user).to eq subscription
    end
  end
end
