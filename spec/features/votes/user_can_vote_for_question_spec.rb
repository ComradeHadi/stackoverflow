require 'features/helper'

feature 'Vote for a question', %q(
  As a user
  I want to be able to vote for (or against) a question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:link_like) { t('vote.action.like') }
  given(:link_dislike) { t('vote.action.dislike') }
  given(:link_withdraw) { t('vote.action.withdraw') }
  given(:question_rating) { ".rating_question" }
  given(:rating_liked) { Votable::LIKE }
  given(:rating_disliked) { Votable::DISLIKE }
  given(:notice_vote_accepted) { t('vote.success.voted') }

  scenario 'User votes for question', js: true do
    log_in user
    visit question_path question

    click_on link_like

    expect(page).to have_content notice_vote_accepted
    within question_rating do
      expect(page).to have_content rating_liked
    end
  end

  scenario 'User votes against question', js: true do
    log_in user
    visit question_path question

    click_on link_dislike

    expect(page).to have_content notice_vote_accepted
    within question_rating do
      expect(page).to have_content rating_disliked
    end
  end

  scenario 'User can not vote multiple times for one question', js: true do
    log_in user
    visit question_path question

    click_on link_like
    expect(page).to_not have_content link_like
  end

  scenario 'User withdraws his vote and votes again', js: true do
    log_in user
    visit question_path question

    click_on link_like
    click_on link_withdraw
    click_on link_dislike

    within question_rating do
      expect(page).to have_content Votable::DISLIKE
    end
  end

  scenario 'Author can not vote for his question', js: true do
    log_in question.author
    visit question_path question
    expect(page).to_not have_content link_like
  end

  scenario 'Guest can not vote for question', js: true do
    visit question_path question
    expect(page).to_not have_content link_like
  end
end
