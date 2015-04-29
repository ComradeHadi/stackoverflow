require 'features/helper'

feature 'Create question', %q(
  As a user
  I want to be able to ask a question
) do
  given(:user) { create(:user) }
  given(:attributes) { attributes_for(:question) }
  given(:label_title) { t('question.label.title') }
  given(:label_body) { t('question.label.body') }
  given(:link_new_question) { t('question.action.new') }
  given(:submit_new_question) { t('question.action.confirm.new') }
  given(:notice_created) { t('flash.actions.create.notice', resource_name: 'Question') }

  scenario 'User creates a question' do
    log_in user
    visit questions_path

    click_on link_new_question
    fill_in label_title, with: attributes[:title]
    fill_in label_body, with: attributes[:body]
    click_on submit_new_question

    expect(page).to have_content notice_created
    expect(page).to have_content attributes[:title]
    expect(page).to have_content attributes[:body]
  end

  scenario 'Guest can not create a question' do
    visit questions_path
    expect(page).to_not have_link link_new_question
  end
end
