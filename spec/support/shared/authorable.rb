shared_examples_for "authorable" do
  it { should belong_to :user }
  it { should validate_presence_of :user }
end
