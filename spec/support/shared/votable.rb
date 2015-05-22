shared_examples_for "votable" do
  # requires votable

  it { should have_many(:votes).dependent(:destroy) }

  describe "votable" do
    let(:votable) { create subject.model_name.element }
    let(:users)      { create_list(:user, 2) }
    let(:user)       { users.at(0) }
    let(:other_user) { users.at(1) }

    context "voting" do
      it "like by user" do
        expect { votable.liked_by user }.to change { votable.votes.count }.by(1)
        expect(votable.voted_by? user).to be true
        expect(votable.vote_by user).to eq Votable::LIKE
      end

      it "dislike by user" do
        expect { votable.disliked_by user }.to change { votable.votes.count }.by(1)
        expect(votable.voted_by? user).to be true
        expect(votable.vote_by user).to eq Votable::DISLIKE
      end

      it "accept only one vote from given user for given votable resource" do
        votable.liked_by user
        expect { votable.liked_by user }.to_not change { votable.votes.count }
        expect { votable.disliked_by user }.to_not change { votable.votes.count }
      end

      it "can be changed later (user withdraw previous vote first, then vote again)" do
        votable.liked_by user
        votable.withdraw_vote_by user
        expect { votable.disliked_by user }.to change { votable.votes.count }.by(1)
        expect(votable.voted_by? user).to be true
      end
    end

    context "rating" do
      it "is 0 by default" do
        expect(votable.rating).to eq 0
      end

      it "increases after like by user" do
        expect { votable.liked_by user }.to change { votable.rating }.by(1)
      end

      it 'increases after likes by different users' do
        votable.liked_by user
        votable.liked_by other_user
        expect(votable.rating).to eq 2
      end

      it "does not change after subsequent votes by same user" do
        votable.liked_by user
        expect { votable.liked_by user }.to_not change { votable.rating }
      end

      it "is changed when user withdraws his vote" do
        votable.liked_by user
        expect { votable.withdraw_vote_by user }.to change { votable.rating }.by(-1)
      end

      it "is changed when user changes his vote" do
        votable.liked_by user
        votable.withdraw_vote_by user
        expect { votable.disliked_by user }.to change { votable.rating }.by(-1)
      end
    end
  end
end
