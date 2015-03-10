require 'rails_helper'

RSpec.describe Question, type: :model do
  it 'validates presence of title' do
    expect( Question.new(body: 'nonempty') ).to_not be_valid
  end

  it 'validates presence if body' do
    expect( Question.new(title: 'nonempty') ).to_not be_valid
  end
end
