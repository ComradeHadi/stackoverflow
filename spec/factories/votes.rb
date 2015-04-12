FactoryGirl.define do
  factory :vote do
    like 1
    user_id 1
    votable_id 1
    votable_type "MyString"
  end
end
