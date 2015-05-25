require 'rails_helper'

RSpec.describe Search, type: :model do
  describe ".options_for_select" do
    it "returns an array" do
      expect(Search.options_for_select).to be_a_kind_of Array
    end

    it "is not empty" do
      expect(Search.options_for_select.size).to be > 0
    end
  end

  describe ".search" do
    it "requires ThinkingSphinx setup for testing models" do
    end
  end
end
