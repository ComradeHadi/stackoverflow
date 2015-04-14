require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:restrict_with_exception) }
  it { should have_many(:questions).dependent(:restrict_with_exception) }
  it { should have_many(:votes).dependent(:restrict_with_exception) }
  it { should have_many(:comments).dependent(:restrict_with_exception) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password}
end
