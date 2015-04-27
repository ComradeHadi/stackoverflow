require 'features/helper'

feature 'Accept answer as the best answer', %q(
  As the question author
  I want to be able to accept a single answer as the best answer to my question
) do
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }
  given(:user) { create(:user) }
  given(:link_accept_as_best_answer) { t('answer.action.accept_as_best') }
  given(:notice_accept_as_best) { t('answer.success.accept_as_best') }
  given(:label_is_best) { t('answer.label.is_best') }
  given(:first_answer) { '.answers .answer:first-child' }
  given(:second_answer) { '.answers .answer:nth-child(2)' }

  scenario 'Any answer can be accepted as the best answer', js: :true do
    log_in question.author
    visit question_path question
    expect(page).to have_link link_accept_as_best_answer, count: question.answers.count
  end

  scenario 'Question author accepts an answer as the best answer', js: true do
    log_in question.author
    visit question_path question

    within first_answer do
      click_on link_accept_as_best_answer
    end

    expect(page).to have_content notice_accept_as_best
    within first_answer do
      expect(page).to have_content label_is_best
    end
  end

  scenario 'Only one answer can be the best answer', js: true do
    log_in question.author
    visit question_path question
    expect(page).to have_content label_is_best, count: 0

    within first_answer do
      click_on link_accept_as_best_answer
    end
    expect(page).to have_content label_is_best, count: 1

    within second_answer do
      click_on link_accept_as_best_answer
    end
    expect(page).to have_content label_is_best, count: 1
  end

  scenario 'Best answer should be the first in answers list', js: true do
    log_in question.author
    visit question_path question

    within second_answer do
      click_on link_accept_as_best_answer
    end

    within first_answer do
      expect(page).to have_content label_is_best
    end
  end

  scenario 'User can not accept answer as the best answer', js: true do
    log_in user
    visit question_path question
    expect(page).to_not have_link link_accept_as_best_answer
  end

  scenario 'Guest can not accept answer as the best answer' do
    visit question_path question
    expect(page).to_not have_link link_accept_as_best_answer
  end
end
