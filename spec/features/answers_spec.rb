require 'rails_helper'

feature 'View answers', %q{
  As a guest or a user
  I want to be able to view answers for a given question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answers) { create_list(:answer, 2, question: question)}
  before { answers }

  scenario 'User can view answers' do
    log_in user
    visit question_path(question.id)
    expect(page).to have_content question.title
    expect(page).to have_content I18n.t('answers.found', count: 2)
  end

  scenario 'Guest can view answers' do
    visit question_path(question.id)
    expect(page).to have_content question.title
    expect(page).to have_content I18n.t('answers.found', count: 2)
  end
end

feature 'Create answer', %q{
  As an authenticated user
  I want to be able to answer an existing question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'User creates an answer to the question' do
    log_in user

    answer = attributes_for(:answer, question: question.id, user: user.id)

    visit question_path(question.id)
    click_on 'Add answer'
    fill_in 'Body', with: answer[:body]
    click_on 'Create'

    expect(page).to have_content I18n.t('answer.created')
    expect(page).to have_content question.title
    expect(page).to have_content answer[:body]
  end

  scenario 'Guest can not answer a question' do
    visit question_path(question.id)
    click_on 'Add answer'
    expect(page).to have_content I18n.t('devise.failure.unauthenticated')
  end
end

