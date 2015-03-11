require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe "GET #index" do
    before do
      @questions = FactoryGirl.create_list(:question, 2)
      get :index
    end

    it 'populates questions array' do
      expect(assigns(:questions)).to match_array(@questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
