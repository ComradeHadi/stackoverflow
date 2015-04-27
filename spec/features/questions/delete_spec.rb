require 'features/helper'

feature 'Delete question', %q(
  As an author
  I want to be able to delete my question
) do
  given!(:question) { create(:question) }
  given(:other_user) { create(:user) }
  given(:link_delete_question) { t('question.action.delete') }
  given(:notice_destroyed) { t('question.success.destroy') }

  scenario 'Author deletes his question from index page', js: true do
    log_in question.user
    visit questions_path
    expect(page).to have_content question.title

    click_on link_delete_question

    expect(page).to have_content notice_destroyed
    expect(page).to_not have_content question.title
  end

  scenario 'Author deletes his question from question page' do
    log_in question.user
    visit question_path question

    click_on link_delete_question

    expect(current_path).to eq questions_path
    expect(page).to have_content notice_destroyed
    expect(page).to_not have_content question.title
  end

  scenario 'User can not delete question of another user' do
    log_in other_user
    visit questions_path
    expect(page).to_not have_link link_delete_question
  end

  scenario 'Guest can not delete any questions' do
    visit questions_path
    expect(page).to_not have_link link_delete_question
  end
end
