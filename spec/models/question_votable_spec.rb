require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'Vote for question' do
    let(:users)      { create_list(:user, 2) }
    let(:user)       { users.at(0) }
    let(:other_user) { users.at(1) }
    let(:question)   { create(:question) }

    it 'like by user' do
      expect{ question.liked_by user }.to change( question.votes, :count ).by(1)
      expect( question.has_vote_by user ).to be true
      expect( question.vote_by user ).to eq Votable::LIKE
    end

    it 'dislike by user' do
      expect{ question.disliked_by user }.to change( question.votes, :count ).by(1)
      expect( question.has_vote_by user ).to be true
      expect( question.vote_by user ).to eq Votable::DISLIKE
    end

    it 'only one vote is accepted from user for any given question' do
      question.liked_by user
      expect{ question.liked_by    user }.to_not change( question.votes, :count )
      expect{ question.disliked_by user }.to_not change( question.votes, :count )
    end

    it 'change vote (withdraw previous vote first, then vote again)' do
      question.liked_by user
      question.withdraw_vote_by user
      expect( question.has_vote_by user ).to be false
      expect{ question.disliked_by user }.to change( question.votes, :count ).by(1)
      expect( question.has_vote_by user ).to be true
    end
  end

  describe 'Question rating' do
    let(:users)      { create_list(:user, 2) }
    let(:user)       { users.at(0) }
    let(:other_user) { users.at(1) }
    let(:question)   { create(:question) }

    it 'question rating is 0 by default' do
      expect( question.rating ).to eq 0
    end

    it 'like by user increase question rating' do
      expect{ question.liked_by user }.to change( question, :rating ).by(1)
    end

    it 'likes by different users increase question rating' do
      question.liked_by user
      expect{ question.liked_by other_user }.to change( question, :rating ).by(1)
    end

    it 'subsequent votes by same user do not change question rating' do
      question.liked_by user
      expect{ question.disliked_by user }.to_not change( question, :rating )
    end

    it 'question rating is changed when user withdraw his vote' do
      question.liked_by user
      expect{ question.withdraw_vote_by user }.to change( question, :rating ).by(-1)
    end

    it 'question rating is changed when user change his vote' do
      question.liked_by user
      question.withdraw_vote_by user
      expect{ question.disliked_by user }.to change( question, :rating ).by(-1)
    end
  end
end
