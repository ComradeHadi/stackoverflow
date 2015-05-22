require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should validate_presence_of :like }
  it { should validate_inclusion_of(:like).in_array [Votable::LIKE, Votable::DISLIKE] }

  it_behaves_like "authorable"
end
