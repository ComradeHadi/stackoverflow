shared_examples_for "votable action unauthorized" do
  # requires votable
  # requires do_request

  before { sign_in votable.author }

  it "does not change rating" do
    expect { do_request }.to_not change { votable.reload.rating }
  end

  it "renders status forbidden" do
    do_request
    expect(response).to be_forbidden
  end
end
