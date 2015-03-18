FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  factory :user do
    email
    password 'B387TNDjQ'
    password_confirmation 'B387TNDjQ'
  end
end
