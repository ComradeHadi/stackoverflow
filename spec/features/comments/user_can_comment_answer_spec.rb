require 'features/helper'

feature 'User comments an answer', %q(
  As a user
  I want to be able to comment and an answer
) do
  given(:user) { create(:user) }
  given(:answer) { create(:answer) }
  given(:attributes) { attributes_for(:comment) }

  given(:el_answer) { "#{dom_id answer}" }
  given(:el_answer_comment) { "#comment_#{ dom_id answer }" }

  scenario 'Author comments his answer', js: true do
    log_in answer.author

    visit question_path answer.question
    within el_answer do
      click_on 'Leave a comment'
    end
    fill_in 'Your comment', with: comment_attr[:body]
    click_on 'Save comment'
    within el_answer do
      expect(page).to have_content comment_attr[:body]
    end
  end

  scenario 'User comments an answer', js: true do
    log_in user

    visit question_path answer.question
    within el_answer do
      click_on 'Leave a comment'
    end
    fill_in 'Your comment', with: comment_attr[:body]
    click_on 'Save comment'
    within el_answer do
      expect(page).to have_content comment_attr[:body]
    end
  end

  scenario 'Guest can not comment an answer', js: true do
    visit question_path answer.question
    expect(page).to_not have_content 'Leave a comment'
  end
end
