require 'features/helper'

feature 'View questions', %q(
  As a guest or a user
  I want to be able to view existing questions
) do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3) }

  scenario 'Any guest can view questions' do
    visit questions_path
    expect(current_path).to eq questions_path
    expect(page).to have_content t('questions.found', count: questions.count)
  end

  scenario 'Authenticated user can view questions' do
    log_in user
    visit questions_path
    expect(page).to have_content t('questions.found', count: questions.count)
  end
end
