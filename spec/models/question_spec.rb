require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should accept_nested_attributes_for :attachments }

  describe 'Vote for question' do
    let(:users)      { create_list(:user, 2) }
    let(:user)       { users.at(0) }
    let(:other_user) { users.at(1) }
    let(:question)   { create(:question) }

    it 'author can not vote for his question' do
      expect( question.user_can_vote? question.user ).to be false
      expect{ question.liked_by       question.user }.to_not change( question.votes, :count )
      expect{ question.downvote_by    question.user }.to_not change( question.votes, :count )
    end

    it 'any other user can vote' do
      expect( question.user_can_vote? user ).to be true
    end

    it 'liked' do
      expect{ question.liked_by user }.to change( question.votes, :count ).by(1)
      expect( question.votes.find_by(user: user).like ).to eq Question::LIKE
    end

    it 'downvote' do
      expect{ question.downvote_by user }.to change( question.votes, :count ).by(1)
      expect( question.votes.find_by(user: user).like ).to eq Question::DISLIKE
    end

    it 'user can vote only once for any given question' do
      question.liked_by user
      expect( question.user_can_vote? user ).to be false
      expect{ question.liked_by       user }.to_not change( question.votes, :count )
      expect{ question.downvote_by    user }.to_not change( question.votes, :count )
    end

    it 'withdraw vote to be able to vote again' do
      question.liked_by user
      question.withdraw_vote_by user
      expect( question.user_can_vote? user ).to be true
      expect{ question.downvote_by user }.to change( question.votes, :count ).by(1)
    end

    it 'rating is 0 by default' do
      expect( question.rating ).to eq 0
    end

    it 'like by user increase question rating' do
      expect{ question.liked_by user }.to change( question, :rating ).by(1)
    end

    it 'subsequent likes by same user are not accepted and do not change rating' do
      expect{ question.liked_by user }.to change( question, :rating ).by(1)
      expect{ question.liked_by user }.to_not change( question, :rating )
    end

    it 'like by question author is not accepted and do not change rating' do
      expect{ question.liked_by question.user }.to_not change( question, :rating )
    end

    it 'rating is changed when user withdraw his vote and then vote again' do
      expect{ question.liked_by user }.to change( question, :rating ).by(1)
      expect{ question.withdraw_vote_by user }.to change( question, :rating ).by(-1)
      expect{ question.downvote_by user }.to change( question, :rating ).by(-1)
    end

  end
end
