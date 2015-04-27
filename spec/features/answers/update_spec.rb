require 'features/helper'

feature 'Update answer', %q(
  As an author
  I want to be able to edit my answer
) do
  given!(:answer) { create(:answer) }
  given(:other_user) { create(:user) }
  given(:attributes) { attributes_for(:answer) }
  given(:label_body) { t('answer.label.body') }
  given(:link_edit_answer) { t('answer.action.edit') }
  given(:submit_save_answer) { t('answer.action.confirm.edit') }
  given(:notice_updated) { t('answer.success.update') }

  scenario 'Author updates his answer', js: true do
    log_in answer.user
    visit question_path answer.question

    click_on link_edit_answer
    fill_in label_body, with: attributes[:body], match: :prefer_exact
    click_on submit_save_answer

    expect(current_path).to eq question_path answer.question
    expect(page).to have_content notice_updated
    expect(page).to have_content attributes[:body]
  end

  scenario 'Users can not edit answers of another user' do
    log_in other_user
    visit question_path answer.question
    expect(page).not_to have_link link_edit_answer
  end

  scenario 'Guest can not edit any answer' do
    visit question_path answer.question
    expect(page).not_to have_link link_edit_answer
  end
end
