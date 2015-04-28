require 'features/helper'

feature 'Create answer on the question page', %q(
  As an authenticated user
  I want to be able to answer on the question page
  Without page reload
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:attributes) { attributes_for(:answer) }
  given(:label_body) { t('answer.label.body') }
  given(:submit_new_answer) { t('answer.action.confirm.new') }

  scenario 'User creates an answer to the question', js: true do
    log_in user
    visit question_path question

    fill_in label_body, with: attributes[:body]
    click_on submit_new_answer

    expect(current_path).to eq question_path question
    within '.answers' do
      expect(page).to have_content attributes[:body]
    end
  end

  scenario 'User tries to create invalid answer', js: true do
    log_in user
    visit question_path question

    click_on submit_new_answer
    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Guest can not answer a question' do
    visit question_path question
    expect(page).to_not have_field label_body
  end
end
