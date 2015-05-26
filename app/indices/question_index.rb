ThinkingSphinx::Index.define :question, name: :question, with: :active_record do
  # fields
  indexes title
  indexes body

  # attributes
  has user_id, created_at, updated_at
end

ThinkingSphinx::Index.define :question, name: :question_with_associations, with: :active_record do
  #fields
  indexes title
  indexes body
  indexes user.email, as: :user_email
  indexes answers.body, as: :answer_body
  indexes comments.body, as: :comments_body

  #attributes
  has user_id, created_at, updated_at
end
