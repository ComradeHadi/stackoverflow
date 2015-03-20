require 'rails_helper'

feature 'Create answer on the question page', %q{
  As an authenticated user
  I want to be able to answer on the question page
  Without page reload
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { attributes_for(:answer) }

  scenario 'User creates an answer to the question', type: :feature, js: :true do
    log_in user

    visit question_path(question.id)
    fill_in 'Your answer', with: answer[:body]
    click_on 'Save answer'
    expect(current_path).to eq question_path(question.id)

    # adding answer with ajax does not set page.notice!
    expect(page).not_to have_content I18n.t('answer.created')

    within '#answers' do
      expect(page).to have_content answer[:body]
    end
  end

  scenario 'Guest can not answer a question' do
    visit question_path(question.id)

    fill_in 'Your answer', with: answer[:body]
    click_on 'Save answer'

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content I18n.t('devise.failure.unauthenticated')
  end
end

