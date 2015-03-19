FactoryGirl.define do
  sequence :title do |n|
    "Question N#{n} title"
  end

  sequence :body do |n|
    "Body N#{n} text"
  end

  factory :question do
    title
    body
    user
  end
  factory :invalid_question, class: "Question" do
    title
    body nil
    user
  end
end
