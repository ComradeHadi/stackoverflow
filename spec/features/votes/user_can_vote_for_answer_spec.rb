require 'features/helper'

feature 'Vote for a answer', %q(
  As a user
  I want to be able to vote for (or against) an answer
) do
  given(:user) { create(:user) }
  given(:answer) { create(:answer) }
  given(:link_like) { t('vote.action.like') }
  given(:link_dislike) { t('vote.action.dislike') }
  given(:link_withdraw) { t('vote.action.withdraw') }
  given(:answer_votes)   { ".votes_answer" }
  given(:answer_rating) { ".rating_answer" }
  given(:rating_liked) { Votable::LIKE }
  given(:rating_disliked) { Votable::DISLIKE }
  given(:notice_vote_accepted) { t('vote.success.voted') }

  scenario 'User votes for answer', js: true do
    log_in user
    visit question_path answer.question

    within answer_votes do
      click_on link_like
    end

    expect(page).to have_content notice_vote_accepted
    within answer_rating do
      expect(page).to have_content rating_liked
    end
  end

  scenario 'User votes against answer', js: true do
    log_in user
    visit question_path answer.question

    within answer_votes do
      click_on link_dislike
    end

    expect(page).to have_content notice_vote_accepted
    within answer_rating do
      expect(page).to have_content rating_disliked
    end
  end

  scenario 'User can not vote multiple times for one answer', js: true do
    log_in user
    visit question_path answer.question

    within answer_votes do
      click_on link_like
      expect(page).to_not have_content link_like
    end
  end

  scenario 'User withdraws his vote and vote again', js: true do
    log_in user
    visit question_path answer.question

    within answer_votes do
      click_on link_like
      click_on link_withdraw
      click_on link_dislike
    end

    within answer_rating do
      expect(page).to have_content rating_disliked
    end
  end

  scenario 'Author can not vote for his answer', js: true do
    log_in answer.author
    visit question_path answer.question

    within answer_votes do
      expect(page).to_not have_content link_like
    end
  end

  scenario 'Guest can not vote for answer', js: true do
    visit question_path answer.question

    expect(page).to_not have_content link_like
  end
end
