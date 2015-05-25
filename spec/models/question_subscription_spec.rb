require 'rails_helper'

RSpec.describe QuestionSubscription, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :question }
  it { should validate_presence_of :user }
end
