require 'features/helper'

feature 'Add files to question', %q{
  As question author
  I want to be able to add files to question
} do

  given(:user) { create(:user) }
  given(:question) { build(:question) }
  given(:test_file) { "#{Rails.root}/spec/features/helper.rb" }

  background do
    log_in user
    visit new_question_path
  end

  scenario 'Author adds files when asking a question', js: :true do
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body

    2.times do |n|
      click_link 'Add a file'
      within ".attachments_new .fields:nth-child(#{ n + 1 })" do
        attach_file 'File', test_file
      end
    end
    click_on 'Create'

    expect(page).to have_content t('question.created')
    expect(page).to have_content 'helper.rb', count: 2
  end
end
