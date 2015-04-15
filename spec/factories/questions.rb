FactoryGirl.define do
  factory :question do
    title { Faker::Lorem.sentence(3) }
    body { Faker::Lorem.paragraph(1) }
    user

    trait :with_files do
      transient do
        files_count 1
      end

      after(:create) do |question, evaluator|
        create_list(:attachment, evaluator.files_count, attachable: question)
      end
    end

    factory :invalid_question do
      body nil
    end
  end
end
