require 'rails_helper'

feature 'Create answer', %q{
  As an authenticated user
  I want to be able to answer an existing question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'User creates an answer to the question' do
    log_in user

    answer = attributes_for(:answer)

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
    expect(current_path).to eq new_user_session_path
    expect(page).to have_content I18n.t('devise.failure.unauthenticated')
  end
end

