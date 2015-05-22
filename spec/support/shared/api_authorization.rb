shared_examples_for "API authenticatable" do
  context 'unauthorized' do
    it 'returns status 401 :unauthorized, if access_token is not provided' do
      get api_path, format: :json
      expect(response).to be_unauthorized
    end

    it 'returns status 401 :unauthorized, if access_token is invalid' do
      get api_path, format: :json, access_token: SecureRandom.hex
      expect(response).to be_unauthorized
    end
  end
end

# OMG, "successfuly responsable"?! No, thanks
shared_examples_for "response ok" do
  it 'returns status 200 :ok' do
    expect(response).to be_success
  end
end

shared_examples_for "creatable" do
  it 'returns status 201 :created' do
    post_create
    expect(response).to be_created
  end
end
