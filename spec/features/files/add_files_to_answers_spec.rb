require 'features/helper'

feature 'Add files to answer', %q(
  As answer author
  I want to be able to add files to answer
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { build(:answer, question: question) }
  given(:test_file) { "#{Rails.root}/spec/features/helper.rb" }

  background do
    log_in user
    visit question_path(question)
  end

  scenario 'Author adds files when posting an answer', js: :true do
    fill_in 'Your answer', with: answer.body

    2.times do |n|
      click_link 'Add a file'
      within ".attachments_new .fields:nth-child(#{ n + 1 })" do
        attach_file 'File', test_file
      end
    end
    click_on 'Save answer'

    expect(page).to have_content t('answer.created')
    within '#answers_list' do
      expect(page).to have_link "helper.rb", count: 2
    end
  end
end
