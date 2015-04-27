require 'features/helper'

feature 'Delete answer without page reload', %q(
  As an author
  I want to be able to delete my answer
) do
  given!(:answers) { create_list(:answer, 2) }
  given(:answer) { answers.first }
  given(:other_user) { create(:user) }
  given(:link_delete_answer) { t('answer.action.delete') }
  given(:notice_destroyed) { t('answer.success.destroy') }

  scenario 'Author can delete his answer', js: true do
    log_in answer.user
    visit question_path answer.question
    expect(page).to have_content answer.body

    click_on link_delete_answer, match: :first

    expect(page).to have_content notice_destroyed
    expect(page).to_not have_content answer.body
  end

  scenario 'Users can not delete answer of another user' do
    log_in other_user
    visit question_path answer.question
    expect(page).to_not have_link link_delete_answer
  end

  scenario 'Guest can not delete any questions' do
    visit question_path answer.question
    expect(page).to_not have_link link_delete_answer
  end
end
