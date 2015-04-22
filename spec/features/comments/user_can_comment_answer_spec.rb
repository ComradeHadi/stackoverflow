require 'features/helper'

feature 'User comments an answer', %q(
  As a user
  I want to be able to comment and an answer
) do
  given(:answer) { create(:answer) }
  given(:answer_author) { answer.user }
  given(:other_user) { create(:user) }

  given(:comment_attr) { attributes_for(:comment) }

  given(:el_answer) { "#{dom_id answer}" }
  given(:el_answer_comment) { "#comment_#{ dom_id answer }" }

  scenario 'Author can comment his answer', js: true do
    log_in answer_author

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

  scenario 'User can comment an answer', js: true do
    log_in other_user

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
    expect(page).not_to have_content 'Leave a comment'
  end
end
