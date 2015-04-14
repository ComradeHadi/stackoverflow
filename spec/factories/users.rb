FactoryGirl.define do
  sequence :email do |n|
     Faker::Internet.email
     # "person#{n}@example.com"
  end

  factory :user do
    email
    password 'B387TNDjQ'
  end
end
