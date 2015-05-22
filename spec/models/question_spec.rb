require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it_behaves_like "authorable"
  it_behaves_like "commentable"
  it_behaves_like "attachable"
  it_behaves_like "votable"

  it { should have_many(:answers).dependent(:destroy) }
end
