FactoryGirl.define do
  sequence(:title) {|n| "Question N#{n} title"}
  sequence(:body)  {|n| "Body N#{n} text"}

  factory :question do
    title
    body
    user

    trait :with_files do
      transient do
        files_count 1
      end

      after(:create) do |question, evaluator|
        create_list(:attachment, evaluator.files_count, attachmentable: question)
      end
    end

    factory :invalid_question do
      body nil
    end
  end
end
