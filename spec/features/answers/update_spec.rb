require 'features/helper'

feature 'Update answer', %q{
  As an author
  I want to be able to edit my answer
} do

  given(:author) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author)}

  scenario 'Author can edit his answer', type: feature, js: true do
    log_in author
    visit question_path(question)
    click_on 'Edit answer'
    expect(current_path).to eq question_path(question)
    fill_in 'Answer', with: 'updated answer', :match => :prefer_exact
    click_on 'Update'
    expect(current_path).to eq question_path(question)
    expect(page).to have_content I18n.t('answer.updated')
    expect(page).to have_content 'updated answer'
  end

  scenario 'Users can not edit answers of another user' do
    log_in other_user
    visit question_path(question)
    expect(page).not_to have_link 'Edit answer'
  end

  scenario 'Guest can not edit any questions' do
    visit question_path(question)
    expect(page).not_to have_link 'Edit answer'
  end
end

