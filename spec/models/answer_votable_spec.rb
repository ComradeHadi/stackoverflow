require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'Vote for answer' do
    let(:users)      { create_list(:user, 2) }
    let(:user)       { users.at(0) }
    let(:other_user) { users.at(1) }
    let(:answer)     { create(:answer) }

    it 'like by user' do
      expect{ answer.liked_by user }.to change( answer.votes, :count ).by(1)
      expect( answer.has_vote_by user ).to be true
      expect( answer.vote_by user ).to eq Votable::LIKE
    end

    it 'dislike by user' do
      expect{ answer.disliked_by user }.to change( answer.votes, :count ).by(1)
      expect( answer.has_vote_by user ).to be true
      expect( answer.vote_by user ).to eq Votable::DISLIKE
    end

    it 'only one vote is accepted from user for any given answer' do
      answer.liked_by user
      expect{ answer.liked_by    user }.to_not change( answer.votes, :count )
      expect{ answer.disliked_by user }.to_not change( answer.votes, :count )
    end

    it 'change vote (withdraw previous vote first, then vote again)' do
      answer.liked_by user
      answer.withdraw_vote_by user
      expect( answer.has_vote_by user ).to be false
      expect{ answer.disliked_by user }.to change( answer.votes, :count ).by(1)
      expect( answer.has_vote_by user ).to be true
    end
  end

  describe 'Answer rating' do
    let(:users)      { create_list(:user, 2) }
    let(:user)       { users.at(0) }
    let(:other_user) { users.at(1) }
    let(:answer)     { create(:answer) }

    it 'answer rating is 0 by default' do
      expect( answer.rating ).to eq 0
    end

    it 'like by user increase answer rating' do
      expect{ answer.liked_by user }.to change( answer, :rating ).by(1)
    end

    it 'likes by different users increase answer rating' do
      answer.liked_by user
      expect{ answer.liked_by other_user }.to change( answer, :rating ).by(1)
    end

    it 'subsequent votes by same user do not change answer rating' do
      answer.liked_by user
      expect{ answer.disliked_by user }.to_not change( answer, :rating )
    end

    it 'answer rating is changed when user withdraw his vote' do
      answer.liked_by user
      expect{ answer.withdraw_vote_by user }.to change( answer, :rating ).by(-1)
    end

    it 'answer rating is changed when user change his vote' do
      answer.liked_by user
      answer.withdraw_vote_by user
      expect{ answer.disliked_by user }.to change( answer, :rating ).by(-1)
    end
  end
end
