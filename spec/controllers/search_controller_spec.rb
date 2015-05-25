require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #search' do
    it "calls Search with given query and search options" do
      expect(Search).to receive(:search).with('query', 'all')
      get :search, query: 'query', search_option: 'all'
    end
  end
end
