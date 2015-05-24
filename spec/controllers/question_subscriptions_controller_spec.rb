require 'rails_helper'

RSpec.describe QuestionSubscriptionsController, type: :controller do
  let!(:question) { create :question }
  let(:user) { create :user }

  describe "GET #create" do
    let(:post_subscription) { post :create, question_id: question, question_subscription: nil }

    context "when authorized" do
      before { sign_in user }

      it "saves subscription in db" do
        expect { post_subscription }.to change { QuestionSubscription.count }.by(1)
      end

      it "saves subscription with correct attributes" do
        post_subscription

        subscription = question.subscription_by user
        expect(subscription.question_id).to eq question.id
        expect(subscription.user_id).to eq user.id
      end
    end

    context "when unauthorized" do
      it "does not save new subscription in db" do
        expect { post_subscription }.to_not change { QuestionSubscription.count }
      end
    end
  end

  describe "GET #destroy" do
    let!(:subscription) { create :question_subscription }
    let(:delete_subscription) { delete :destroy, id: subscription, format: :js }

    context "when authorized" do
      before { sign_in subscription.user }

      it "deletes subscription" do
        expect { delete_subscription }.to change { QuestionSubscription.count }.by(-1)
      end
    end

    context "when unauthorized" do
      before { sign_in user }

      it "does not delete subscription" do
        expect { delete_subscription }.to_not change { QuestionSubscription.count }
      end
    end
  end
end
