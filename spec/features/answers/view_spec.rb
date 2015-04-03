require 'features/helper'

feature 'View answers', %q{
  As a guest or a user
  I want to be able to view answers for a given question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 2, question: question)}

  scenario 'User can view answers' do
    log_in user
    visit question_path(question.id)
    expect(page).to have_content question.title
    expect(page).to have_content t('answers.found', count: 2)
  end

  scenario 'Guest can view answers' do
    visit question_path(question.id)
    expect(page).to have_content question.title
    expect(page).to have_content t('answers.found', count: 2)
  end
end

