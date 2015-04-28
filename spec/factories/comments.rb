FactoryGirl.define do
  factory :comment do
    body { Faker::Lorem.paragraph }
    user
    factory :invalid_comment do
      body ""
    end
  end
end
