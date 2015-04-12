if @answer.errors.any?
  json.errors @answer.errors.full_messages
else
  json.(@answer, :id, :body)

  json.attachments @answer.attachments do |attachment|
    json.id attachment.id
    json.name attachment.file_identifier
    json.url attachment.file.url
  end

  json.is_author (user_signed_in? and (@answer.user_id == current_user.id))
  json.is_question_author (user_signed_in? and (@question.user_id == current_user.id))
end
