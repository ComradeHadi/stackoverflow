require 'features/helper'

feature 'Update question', %q(
  As an author
  I want to be able to update my question (without page reload)
) do
  given(:question) { create(:question) }
  given(:user) { create(:user) }
  given(:attributes) { attributes_for(:question) }
  given(:label_title) { t('question.label.title') }
  given(:label_body) { t('question.label.body') }
  given(:link_edit_question) { t('question.action.edit') }
  given(:sumbit_save_question) { t('question.action.confirm.edit') }
  given(:notice_updated) { t('question.success.update') }

  scenario 'Author updates his question', js: true do
    log_in question.author
    visit question_path question

    click_on link_edit_question
    fill_in label_title, with: attributes[:title]
    fill_in label_body, with: attributes[:body]
    click_on sumbit_save_question

    expect(current_path).to eq question_path question
    expect(page).to have_content notice_updated
  end

  scenario 'User can not edit question of another user' do
    log_in user
    visit question_path question
    expect(page).to_not have_link link_edit_question
  end

  scenario 'Guest can not edit any questions' do
    visit question_path question
    expect(page).to_not have_link link_edit_question
  end
end
