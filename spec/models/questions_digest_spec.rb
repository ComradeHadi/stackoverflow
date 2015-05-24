require 'rails_helper'

RSpec.describe QuestionsDigest, type: :model do
  let(:users) { create_list :user, 3 }
  let!(:question) { create :question }

  describe ".send_daily_digest" do
    it "sends dayly digest to all users" do
      User.all do |user|
        expect(DigestMailer).to receive(:dayly_digest).with(user).and_call_original
      end
      QuestionsDigest.send_daily_digest
    end
  end
end
