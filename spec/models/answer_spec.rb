require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }

  it { should belong_to(:question) }

  # this test will fail without extra condition "if is_best: true"
  # but conditions are not supported by validate_uniqueness_of matcher
  # it { should validate_uniqueness_of(:is_best).scoped_to(:question_id) } #.if(is_best: true)
end

