require 'features/helper'

feature 'View questions', %q(
  As a guest or a user
  I want to be able to view existing questions
) do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3) }

  scenario 'User can view questions' do
    log_in user
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end

  scenario 'Guest can view questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
