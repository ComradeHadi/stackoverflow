FactoryGirl.define do
  factory :attachment do
    attachmentable_id nil
    file { File.new("#{Rails.root}/spec/features/helper.rb") }

    factory :attachment_to_question do
      attachmentable_type "Question"
    end

    factory :attachment_to_answer do
      attachmentable_type "Answer"
    end

  end
end

