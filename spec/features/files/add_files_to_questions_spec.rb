require 'features/helper'

feature 'Add files to question', %q{
  As question author
  I want to be able to add files to question
} do

  given(:user) { create(:user) }
  given(:question) { build(:question) }

  background do
    log_in user
    visit new_question_path
  end

  scenario 'Author adds file when asking question', js: :true do
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    attach_file 'File', "#{Rails.root}/spec/features/helper.rb"
    click_on 'Create'

    expect(page).to have_content I18n.t('question.created')    
    expect(page).to have_content question.title
    expect(page).to have_content "helper.rb"
  end
end
