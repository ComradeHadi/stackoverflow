FactoryGirl.define do
  factory :identity do
    user
    provider nil
    uid { Faker::Code.ean }
    email nil
    confirmation_token nil
  end
end
