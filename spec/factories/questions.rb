FactoryGirl.define do
  sequence(:title) {|n| "Question N#{n} title"}
  sequence(:body)  {|n| "Body N#{n} text"}

  factory :question do
    title
    body
    user

    factory :invalid_question do
      body nil
    end

    factory :question_with_attachment do
      after(:create) do |question, evaluator|
        question.attachments << FactoryGirl.build(:attachment_to_question, attachmentable_id: question.id)
      end
    end

  end
end
