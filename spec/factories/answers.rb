FactoryGirl.define do
  sequence :answer_body do |n|
    "Answer N#{n}"
  end

  factory :answer do
    body { generate(:answer_body) }
    question
    user
    is_best false
  end
  factory :invalid_answer, class: "Answer" do
    body nil
    user
    is_best false
  end
end
