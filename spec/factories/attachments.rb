FactoryGirl.define do
  factory :attachment do
    file { File.new("#{Rails.root}/spec/features/helper.rb") }
  end
end

