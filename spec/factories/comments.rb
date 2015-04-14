FactoryGirl.define do
  factory :comment do
    body "My comment"
    user
    factory :invalid_comment do
      body ""
    end
  end
end
