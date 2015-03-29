FactoryGirl.define do
  sequence(:answer_body) {|n| "Answer N#{n}" }

  factory :answer do
    body { generate(:answer_body) }
    question
    user
    is_best false

    factory :invalid_answer do
      body nil
    end

    factory :answer_with_attachment do
      after(:create) do |answer, evaluator|
        answer.attachments << FactoryGirl.build(:attachment_to_answer, attachmentable_id: answer.id)
      end
    end
  end
end
