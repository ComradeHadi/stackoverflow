require 'features/helper'

feature 'Create answer on the question page', %q(
  As an authenticated user
  I want to be able to answer on the question page
  Without page reload
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { attributes_for(:answer) }

  scenario 'User creates an answer to the question', js: true do
    log_in user

    visit question_path question
    fill_in t('answer.label.body'), with: answer[:body]
    click_on t('answer.action.confirm.new')
    expect(current_path).to eq question_path(question.id)

    within '#answers' do
      expect(page).to have_content answer[:body]
    end
  end

  scenario 'User tries to create invalid answer', js: true do
    log_in user

    visit question_path(question.id)
    click_on t('answer.action.confirm.new')
    expect(current_path).to eq question_path(question.id)

    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Guest can not answer a question' do
    visit question_path(question.id)
    expect(page).not_to have_field t('answer.label.body')
  end
end
