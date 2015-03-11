require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should have_many(:answers).dependent(:destroy) }

  describe "destroy question" do
    it "should destroy dependent answers" do
      question1 = FactoryGirl.create(:question)
      answer1 = FactoryGirl.create(:answer, question_id: question1.id)
      answer2 = FactoryGirl.create(:answer, question_id: question1.id)

      expect { question1.destroy! }.to change{ Answer.count }.by(-2)
    end
  end
end
