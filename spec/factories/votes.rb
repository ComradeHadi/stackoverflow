FactoryGirl.define do
  factory :vote do
    like Votable::LIKE
    user
    votable_id 1
    votable_type "MyString"
  end
end
