require 'rails_helper'

feature 'Update answer', %q{
  As an author
  I want to be able to edit my answer
} do

  given(:author) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given(:answer) { create(:answer, question: question, user: author)}
  before { answer }

  scenario 'Author can edit his answer' do
    log_in author
    visit question_path(question)
    click_on 'Edit answer'
    expect(current_path).to eq edit_answer_path(answer)
    fill_in 'Body', with: 'Updated body'
    click_on 'Update'
    expect(current_path).to eq question_path(question)
    expect(page).to have_content I18n.t('answer.updated')
    expect(page).to have_content 'Updated body'
  end
  scenario 'Users can not edit answers of another user' do
    log_in other_user
    visit question_path(question)
    click_on 'Edit answer'
    expect(current_path).to eq question_path(question)
    expect(page).to have_content I18n.t('answer.failure.not_an_author')
    expect(page).not_to have_content 'Updated body'
  end
  scenario 'Guest can not edit any questions' do
    visit question_path(question)
    click_on 'Edit answer'
    expect(current_path).to eq new_user_session_path
    expect(page).to have_content I18n.t('devise.failure.unauthenticated')
  end
end

