require 'features/helper'

feature 'Accept answer as the best answer', %q{
  As the question author
  I want to be able to accept a single answer as the best answer to my question
} do

  given(:question_author) { create(:user) }
  given(:other_user) { create(:user) }

  given!(:question) { create(:question, user: question_author) }
  given!(:answers) { create_list(:answer, 3, question: question, user: other_user) }

  scenario 'Question author can accept any answer as the best answer', type: :feature, js: :true do
    log_in question_author
    answer = answers.at(0)

    visit question_path(question.id)

    # any answer can be accepted as best
    expect(page).to have_selector('.accept_as_best', question.answers.count)

    click_on "best_answer_#{ answer.id }"
    expect(current_path).to eq question_path(question.id)
    within "#answer_#{ answer.id }" do
      expect(page).to have_content I18n.t('answer.is_best')
    end
  end

  scenario 'Only one answer can be the best answer', type: :feature, js: :true do
    log_in question_author
    first_best_answer = answers.at(1)

    visit question_path(question.id)
    click_on "best_answer_#{ first_best_answer.id }"

    within "#answer_#{ first_best_answer.id }" do
      expect(page).to have_content I18n.t('answer.is_best')
    end

    other_answer_accepted_as_best = answers.at(2)
    click_on "best_answer_#{ other_answer_accepted_as_best.id }"

    # other answer is accepted as the best answer
    within "[id^='answer_#{ other_answer_accepted_as_best.id }']" do
      expect(page).to have_content I18n.t('answer.is_best')
    end
    # previous "best answer" is not marked as "best" anymore
    within "[id^='answer_#{ first_best_answer.id }']" do
      expect(page).not_to have_content I18n.t('answer.is_best')
    end
  end

  scenario 'Other user can not accept answer as the best answer', js: :true do
    log_in other_user

    visit question_path(question.id)
    expect(page).not_to have_link I18n.t('answer.accept_as_best')
  end

  scenario 'Guest can not accept answer as the best answer' do
    visit question_path(question.id)
    expect(page).not_to have_link I18n.t('answer.accept_as_best')
  end
end

