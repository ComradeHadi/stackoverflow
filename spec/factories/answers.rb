FactoryGirl.define do
  factory :answer do
    body { Faker::Lorem.paragraph(2) }
    question
    user
    is_best false

    trait :with_files do
      transient do
        files_count 1
      end

      after(:create) do |answer, evaluator|
        create_list(:attachment, evaluator.files_count, attachable: answer)
      end
    end

    factory :invalid_answer do
      body nil
    end
  end
end
