require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:restrict_with_exception) }
  it { should have_many(:questions).dependent(:restrict_with_exception) }
  it { should have_many(:votes).dependent(:restrict_with_exception) }
  it { should have_many(:comments).dependent(:restrict_with_exception) }

  it { should have_many(:identities).dependent(:delete_all) }
  it { should have_many(:question_subscriptions).dependent(:delete_all) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe ".find_for_auth" do
    let(:uid) { Faker::Code.ean }
    let(:provider) { 'provider' }
    let(:oauth) { OmniAuth::AuthHash.new(provider: provider, uid: uid) }
    let!(:user) { create :user }

    context "User already has oauth identity for provider" do
      it "returns the existing user" do
        user.identities.create(provider: provider, uid: uid)
        expect(User.find_for_auth(oauth)).to eq user
      end
    end

    context "User has no stored oauth identity for provider" do
      context "User with given email already exists" do
        let(:user_info) { { email: user.email } }
        let(:oauth) { OmniAuth::AuthHash.new(provider: provider, uid: uid, info: user_info) }

        it "returns user" do
          expect(User.find_for_auth(oauth)).to eq user
        end

        it "does not create new user" do
          expect { User.find_for_auth(oauth) }.to_not change { User.count }
        end

        it "creates identity for user" do
          expect { User.find_for_auth(oauth) }.to change { user.identities.count }.by(1)
        end

        it "creates identity with correct attributes" do
          identity = User.find_for_auth(oauth).identities.first

          expect(identity.provider).to eq oauth.provider
          expect(identity.uid).to eq oauth.uid
        end
      end

      context "User with given email is a new user" do
        let(:user_info) { { email: Faker::Internet.email } }
        let(:oauth) { OmniAuth::AuthHash.new(provider: provider, uid: uid, info: user_info) }

        it "creates new user" do
          expect { User.find_for_auth(oauth) }.to change { User.count }.by(1)
        end

        it "returns new user" do
          expect(User.find_for_auth(oauth)).to be_a User
        end

        it "fills user email" do
          user = User.find_for_auth(oauth)
          expect(user.email).to eq oauth.info[:email]
        end

        it "creates identity for user" do
          expect(User.find_for_auth(oauth).identities).to_not be_empty
        end

        it "creates identity with correct attributes" do
          identity = User.find_for_auth(oauth).identities.first

          expect(identity.provider).to eq oauth.provider
          expect(identity.uid).to eq oauth.uid
        end
      end

      context "OAUTH provider does not return email" do
        let(:user_info) { {} }
        let(:oauth) { OmniAuth::AuthHash.new(provider: provider, uid: uid, info: user_info) }

        it "does not create new user" do
          expect { User.find_for_auth(oauth) }.to_not change { User.count }
        end

        it "creates new identity" do
          expect { User.find_for_auth(oauth) }.to change { Identity.count }.by(1)
        end

        it "creates identity with correct attributes" do
          identity = User.find_for_auth(oauth).identities.first

          expect(identity.provider).to eq oauth.provider
          expect(identity.uid).to eq oauth.uid
        end
      end
    end
  end
end
