require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :user }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :like }
  
  it { should validate_inclusion_of(:like).in_array( %w(-1, 1) ) } 

  describe 'Vote for question' do
    let(:users)      { create_list(:user, 2) }
    let(:user)       { users.at(0) }
    let(:other_user) { users.at(1) }
    let(:question)   { create(:question) }

    it 'author can not vote' do
      expect( question.user_can_vote? question.user ).to be false
      expect{ question.liked_by       question.user }.to_not change( question.votes, :count )
      expect{ question.downvote_by    question.user }.to_not change( question.votes, :count )
    end

    it 'user can vote' do
      expect( question.user_can_vote? user ).to be true
    end

    it 'like by user' do
      expect{ question.liked_by user }.to change( question.votes, :count ).by(1)
      expect( question.votes.find_by(user: user).like ).to eq Question::LIKE
    end

    it 'downvote by user' do
      expect{ question.downvote_by user }.to change( question.votes, :count ).by(1)
      expect( question.votes.find_by(user: user).like ).to eq Question::DISLIKE
    end

    it 'only one vote per user' do
      question.liked_by user
      expect( question.user_can_vote? user ).to be false
      expect{ question.liked_by       user }.to_not change( question.votes, :count )
      expect{ question.downvote_by    user }.to_not change( question.votes, :count )
    end

    it 'withdraw vote first to vote againg' do
      question.liked_by user
      question.withdraw_vote_by user
      expect( question.user_can_vote? user ).to be true
      expect{ question.downvote_by user }.to change( question.votes, :count ).by(1)
    end

    it 'rating' do
      expect( question.rating ).to eq 0

      expect{ question.liked_by user }.to change( question, :rating ).by(1)
      expect{ question.liked_by user }.to_not change( question, :rating )

      expect{ question.liked_by other_user }.to change( question, :rating ).by(1)

      expect{ question.liked_by question.user }.to_not change( question, :rating )

      expect{ question.downvote_by user }.to_not change( question, :rating )

      expect{ question.withdraw_vote_by user }.to change( question, :rating ).by(-1)
      expect{ question.downvote_by user }.to change( question, :rating ).by(-1)
    end
  end
end
