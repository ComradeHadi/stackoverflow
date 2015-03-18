require 'rails_helper'

feature 'View answers', %q{
  As a guest or a user
  I want to be able to view answers for a given question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answers) { create_list(:answer, 2, question: question)}
  before { answers }

  scenario 'User can view answers' do
    log_in user
    visit question_path(question.id)
    expect(page).to have_content question.title
    expect(page).to have_content I18n.t('answers.found', count: 2)
  end

  scenario 'Guest can view answers' do
    visit question_path(question.id)
    expect(page).to have_content question.title
    expect(page).to have_content I18n.t('answers.found', count: 2)
  end
end

feature 'Create answer', %q{
  As an authenticated user
  I want to be able to answer an existing question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'User creates an answer to the question' do
    log_in user

    answer = attributes_for(:answer, question: question.id, user: user.id)

    visit question_path(question.id)
    click_on 'Add answer'
    fill_in 'Body', with: answer[:body]
    click_on 'Create'

    expect(page).to have_content I18n.t('answer.created')
    expect(page).to have_content question.title
    expect(page).to have_content answer[:body]
  end

  scenario 'Guest can not answer a question' do
    visit question_path(question.id)
    click_on 'Add answer'
    expect(current_path).to eq new_user_session_path
    expect(page).to have_content I18n.t('devise.failure.unauthenticated')
  end
end

feature 'Delete answer', %q{
  As an author
  I want to be able to delete my answer
} do

  given(:author) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given(:answers) { create_list(:answer, 3, question: question, user: author) }
  given(:answer) { answers.at(1) }
  before { answer  }

  scenario 'Author can delete his answer' do
    log_in author

    # answers are listed only under question page
    visit question_path(question)
    expect(page).to have_content I18n.t('answers.found', count: 3)
save_page
    click_on "delete_answer_#{ answer.id }"
    expect(page).to have_content I18n.t('answer.destroyed')
    expect(page).to have_content I18n.t('answers.found', count: 2)
    expect(current_path).to eq question_path(question)
  end
  scenario 'Users can not delete answer of another user' do
    log_in other_user

    # answers are listed only under question page
    visit question_path(question)
    click_on "delete_answer_#{ answer.id }"
    expect(page).to have_content I18n.t('answer.failure.not_an_author')
    expect(current_path).to eq question_path(question)
  end
  scenario 'Guest can not delete any questions' do
    visit question_path(question)
    click_on "delete_answer_#{ answer.id }"
    expect(current_path).to eq new_user_session_path
    expect(page).to have_content I18n.t('devise.failure.unauthenticated')
  end
end

feature 'Update answer', %q{
  As an author
  I want to be able to edit my answer
} do

  given(:author) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given(:answer) { create(:answer, question: question, user: author)}
  before { answer }

  scenario 'Author can edit his answer' do
    log_in author
    visit question_path(question)
    click_on 'Edit answer'
    expect(current_path).to eq edit_answer_path(answer)
    fill_in 'Body', with: 'Updated body'
    click_on 'Update'
    expect(current_path).to eq question_path(question)
    expect(page).to have_content I18n.t('answer.updated')
    expect(page).to have_content 'Updated body'
  end
  scenario 'Users can not edit answers of another user' do
    log_in other_user
    visit question_path(question)
    click_on 'Edit answer'
    expect(current_path).to eq question_path(question)
    expect(page).to have_content I18n.t('answer.failure.not_an_author')
    expect(page).not_to have_content 'Updated body'
  end
  scenario 'Guest can not edit any questions' do
    visit question_path(question)
    click_on 'Edit answer'
    expect(current_path).to eq new_user_session_path
    expect(page).to have_content I18n.t('devise.failure.unauthenticated')
  end
end

