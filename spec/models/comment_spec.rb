require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :commentable }
  it { should validate_presence_of :body }

  it_behaves_like "authorable"
end
