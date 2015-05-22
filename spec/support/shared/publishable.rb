shared_examples_for "publishable" do
  # requires do_request
  # requires publish_channel

  it "publishes to given channel for subscribers" do
    expect(PrivatePub).to receive(:publish_to).with(publish_channel, anything)
    do_request
  end
end

shared_examples_for "not publishable" do
  # requires do_request

  it "does not publish anything" do
    expect(PrivatePub).to_not receive(:publish_to)
    do_request
  end
end
