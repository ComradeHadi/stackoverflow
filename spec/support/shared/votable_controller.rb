shared_examples_for "Votable Controller" do
  # requires votable

  let(:user) { create :user }
  let(:patch_like) { patch :like, id: votable, format: :js }
  let(:patch_dislike) { patch :dislike, id: votable, format: :js }
  let(:patch_withdraw_vote) { patch :withdraw_vote, id: votable, format: :js }

  describe "PATCH #like" do
    let(:do_request) { patch_like }

    context "when authorized" do
      before { sign_in user }

      it "increase rating" do
        expect { patch_like }.to change { votable.reload.rating }.by(1)
      end

      it "renders partial votes/update" do
        patch_like
        expect(response).to render_template 'votes/update'
      end
    end

    context "when unauthorized" do
      it_behaves_like "votable action unauthorized"
    end
  end

  describe "PATCH #dislike" do
    let(:do_request) { patch_dislike }

    context "when authorized" do
      before { sign_in user }

      it "decrease rating" do
        expect { patch_dislike }.to change { votable.reload.rating }.by(-1)
      end

      it "renders partial votes/update" do
        patch_dislike
        expect(response).to render_template 'votes/update'
      end
    end

    context "when unauthorized" do
      it_behaves_like "votable action unauthorized"
    end
  end

  describe "PATCH #withdraw_vote" do
    let(:do_request) { patch_withdraw_vote }

    context "when authorized" do
      before { sign_in user }

      it "returns rating back to zero" do
        patch_like
        patch_withdraw_vote
        expect(votable.reload.rating).to eq 0
      end

      it "does not change rating after second and subsequent calls" do
        patch_like
        patch_withdraw_vote
        expect { patch_withdraw_vote }.to_not change { votable.reload.rating }
      end

      it "renders partial votes/update" do
        patch_like
        patch_withdraw_vote
        expect(response).to render_template 'votes/update'
      end
    end

    context "when unauthorized" do
      it_behaves_like "votable action unauthorized"
    end
  end
end
