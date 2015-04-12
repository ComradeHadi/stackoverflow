require 'features/helper'

feature 'Vote for a question', %q{
  As a user
  I want to be able to vote for (or against) a question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:question_author) { question.user }
  given(:question_rating) { "#rating_question_#{ question.id }" }

  scenario 'User (but not author) can vote for question', js: true do
    log_in user
    visit question_path question

    click_on 'Like'

    expect(page).to have_content t('vote.accepted')
    within question_rating do
      expect(page).to have_content '1'
    end
  end

  scenario 'User (but not author) can vote against question', js: true do
    log_in user
    visit question_path question

    click_on 'Dislike'

    expect(page).to have_content t('vote.accepted')
    within question_rating do
      expect(page).to have_content '-1'
    end
  end

  scenario 'User can not vote multiple times for one question' , js: true do
    log_in user
    visit question_path question

    click_on 'Like'
    expect(page).not_to have_content 'Like'
  end

  scenario 'User can withdraw his vote and vote again', js: true do
    log_in user
    visit question_path question

    click_on 'Like'
    click_on 'Withdraw'
    within question_rating do
      expect(page).to have_content '0'
    end

    click_on 'Dislike'
    within question_rating do
      expect(page).to have_content '-1'
    end
  end

  scenario 'Author can not vote for his question', js: true do
    log_in question_author
    visit question_path question

    expect(page).not_to have_content 'Like'
  end

  scenario 'User can not vote for question', js: true do
    visit question_path question

    expect(page).not_to have_content 'Like'
  end
end
