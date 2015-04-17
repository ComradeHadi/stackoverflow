require 'features/helper'

feature 'Vote for a answer', %q{
  As a user
  I want to be able to vote for (or against) an answer
} do

  given(:user) { create(:user) }
  given(:answer) { create(:answer) }
  given(:answer_author) { answer.user }
  given(:answer_vote)   { "#vote_answer_#{ answer.id }" }
  given(:answer_rating) { "#rating_answer_#{ answer.id }" }

  scenario 'User (but not author) can vote for answer', js: true do
    log_in user
    visit question_path answer.question

    within answer_vote do
      click_on 'Like'
    end

    expect(page).to have_content t('vote.accepted')
    within answer_rating do
      expect(page).to have_content '1'
    end
  end

  scenario 'User (but not author) can vote against answer', js: true do
    log_in user
    visit question_path answer.question

    within answer_vote do
      click_on 'Dislike'
    end

    expect(page).to have_content t('vote.accepted')
    within answer_rating do
      expect(page).to have_content '-1'
    end
  end

  scenario 'User can not vote multiple times for one answer' , js: true do
    log_in user
    visit question_path answer.question

    within answer_vote do
      click_on 'Like'
      expect(page).not_to have_content 'Like'
    end
  end

  scenario 'User can withdraw his vote and vote again', js: true do
    log_in user
    visit question_path answer.question

    within answer_vote do
      click_on 'Like'
      click_on 'Withdraw'
    end

    within answer_rating do
      expect(page).to have_content '0'
    end

    within answer_vote do  
      click_on 'Dislike'
    end

    within answer_rating do
      expect(page).to have_content '-1'
    end
  end

  scenario 'Author can not vote for his answer', js: true do
    log_in answer_author
    visit question_path answer.question

    within answer_vote do
      expect(page).not_to have_content 'Like'
    end
  end

  scenario 'Guest can not vote for answer', js: true do
    visit question_path answer.question

    expect(page).not_to have_content 'Like'
  end
end
