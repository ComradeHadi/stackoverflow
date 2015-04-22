require 'features/helper'

feature 'Delete answer without page reload', %q(
  As an author
  I want to be able to delete my answer
) do
  given(:author) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answers) { create_list(:answer, 3, question: question, user: author) }
  given!(:answer) { answers.at(1) }

  scenario 'Author can delete his answer', js: true do
    log_in author

    # answers are listed only under question page
    visit question_path(question)
    expect(page).to have_content t('answers.found', count: 3)
    click_on "delete_answer_#{ answer.id }"
    expect(page).to have_content t('answer.destroyed')
    expect(page).to have_content t('answers.found', count: 2)
    expect(current_path).to eq question_path(question)
  end

  scenario 'Users can not delete answer of another user' do
    log_in other_user
    visit question_path(question)
    expect(page).not_to have_link('Delete answer')
  end

  scenario 'Guest can not delete any questions' do
    visit question_path(question)
    expect(page).not_to have_link('Delete answer')
  end
end
