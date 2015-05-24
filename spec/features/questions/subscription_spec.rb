require 'features/helper'

feature 'Subscribe to question', %q(
  As a user
  I want to be able to subscribe and unsubscribe to question
  In order to receive email notifications of new answers
) do
  given(:user) { create :user }
  given(:question) { create :question }
  given(:link_subscribe) { t('question.action.subscribe') }
  given(:link_unsubscribe) { t('question.action.unsubscribe') }

  scenario "User subscribes to question", js: true do
    log_in user
    visit question_path question

    click_on link_subscribe

    expect(current_path).to eq question_path question
    within '.subscription_question' do
      expect(page).to_not have_content link_subscribe
      expect(page).to have_content link_unsubscribe
    end
  end

  scenario "Subscribed user unsubscribes", js: true do
    question.subscribers << user

    log_in user
    visit question_path question

    click_on link_unsubscribe

    expect(current_path).to eq question_path question
    within '.subscription_question' do
      expect(page).to have_content link_subscribe
      expect(page).to_not have_content link_unsubscribe
    end
  end


  scenario "Question author is automatically subscribed to his question" do
    log_in question.author
    visit question_path question

    within '.subscription_question' do
      expect(page).to have_content link_unsubscribe
    end
  end

  scenario "Guest can not subscribe" do
    log_in question.author
    visit question_path question

    within '.subscription_question' do
      expect(page).to_not have_content link_subscribe
    end
  end
end
