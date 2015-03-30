FactoryGirl.define do
  sequence(:answer_body) {|n| "Answer N#{n}" }

  factory :answer do
    body { generate(:answer_body) }
    question
    user
    is_best false

    trait :with_files do
      transient do
        files_count 1
      end

      after(:create) do |answer, evaluator|
        create_list(:attachment, evaluator.files_count, attachmentable: answer)
      end
    end

    factory :invalid_answer do
      body nil
    end
  end
end
