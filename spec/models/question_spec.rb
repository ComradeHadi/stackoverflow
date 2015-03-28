require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }

  describe "destroy question" do
    it "should destroy dependent answers" do
      question = create(:question)
      answers = create_list(:answer, 2, question: question)
      expect { question.destroy! }.to change{ Answer.count }.by(-2)
    end
  end
end
