FactoryGirl.define do
  factory :question do
    title "MyString"
    body "MyText"
    user
  end
  factory :invalid_question, class: "Question" do
    title "Invalid Question"
    body nil
    user
  end
end
