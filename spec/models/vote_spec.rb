require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :user }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :like }
  it { should validate_inclusion_of(:like).in_array [Votable::LIKE, Votable::DISLIKE] }

  let(:users)      { create_list(:user, 2) }
  let(:user)       { users.at(0) }
  let(:other_user) { users.at(1) }
  let(:question)   { create(:question) }
  let(:answer)     { create(:answer, question: question) }

  [:question, :answer].each do |votable_name|
    before { @votable = send votable_name }

    describe "vote for #{votable_name}" do

      it "like by user" do
        expect{ @votable.liked_by    user }.to change( @votable.votes, :count ).by(1)
        expect( @votable.has_vote_by user ).to be true
        expect( @votable.vote_by     user ).to eq Votable::LIKE
      end

      it "dislike by user" do
        expect{ @votable.disliked_by user }.to change( @votable.votes, :count ).by(1)
        expect( @votable.has_vote_by user ).to be true
        expect( @votable.vote_by     user ).to eq Votable::DISLIKE
      end

      it "only one vote is accepted from user for any given #{votable_name}" do
        @votable.liked_by user
        expect{ @votable.liked_by    user }.to_not change( @votable.votes, :count )
        expect{ @votable.disliked_by user }.to_not change( @votable.votes, :count )
      end

      it "change vote (withdraw previous vote first, then vote again)" do
        @votable.liked_by user
        @votable.withdraw_vote_by user
        expect( @votable.has_vote_by user ).to be false
        expect{ @votable.disliked_by user }.to change( @votable.votes, :count ).by(1)
        expect( @votable.has_vote_by user ).to be true
      end
    end

    describe "#{ votable_name } rating" do

      it "#{ votable_name } rating is 0 by default" do
        expect( @votable.rating ).to eq 0
      end

      it "like by user increase #{ votable_name } rating" do
        expect{ @votable.liked_by user }.to change( @votable, :rating ).by(1)
      end

      it 'likes by different users increase question rating' do
        @votable.liked_by user
        expect{ @votable.liked_by other_user }.to change( @votable, :rating ).by(1)
      end

      it "subsequent votes by same user do not change #{ votable_name } rating" do
        @votable.liked_by user
        expect{ @votable.disliked_by user }.to_not change( @votable, :rating )
      end

      it "#{ votable_name } rating is changed when user withdraw his vote" do
        @votable.liked_by user
        expect{ @votable.withdraw_vote_by user }.to change( @votable, :rating ).by(-1)
      end

      it "#{ votable_name } rating is changed when user change his vote" do
        @votable.liked_by user
        @votable.withdraw_vote_by user
        expect{ @votable.disliked_by user }.to change( @votable, :rating ).by(-1)
      end
    end

  end
end
