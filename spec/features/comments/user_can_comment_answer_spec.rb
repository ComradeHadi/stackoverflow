require 'features/helper'

feature 'User comments an answer', %q(
  As a user
  I want to be able to comment and an answer
) do
  given(:user) { create(:user) }
  given(:answer) { create(:answer) }
  given(:question) { answer.question }
  given(:attributes) { attributes_for(:comment) }
  given(:label_body) { t('comment.label.body') }
  given(:link_new_comment) { t('comment.action.new') }
  given(:submit_new_comment) { t('comment.action.confirm.new') }
  given(:answer_element) { '.answers .answer:first-child' }
  given(:answer_comments) { '.answer .comments' }

  scenario 'Author comments his answer', js: true do
    log_in answer.author
    visit question_path question

    within answer_element do
      click_on link_new_comment
    end
    fill_in label_body, with: attributes[:body]
    click_on submit_new_comment

    within answer_comments do
      expect(page).to have_content attributes[:body]
    end
  end

  scenario 'User comments an answer', js: true do
    log_in user
    visit question_path question

    within answer_element do
      click_on link_new_comment
    end
    fill_in label_body, with: attributes[:body]
    click_on submit_new_comment

    within answer_comments do
      expect(page).to have_content attributes[:body]
    end
  end

  scenario 'Guest can not comment an answer', js: true do
    visit question_path question
    expect(page).to_not have_content link_new_comment
  end
end
