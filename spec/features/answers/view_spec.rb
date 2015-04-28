require 'features/helper'

feature 'View answers', %q(
  As a guest or a user
  I want to be able to view answers for a given question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  scenario 'User can view answers' do
    log_in user
    visit question_path question

    question.answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

  scenario 'Guest can view answers' do
    visit question_path question

    question.answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
