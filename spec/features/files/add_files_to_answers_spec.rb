require 'features/helper'

feature 'Add files to answer', %q{
  As answer author
  I want to be able to add files to question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { build(:answer, question: question) }

  background do
    log_in user
    visit question_path(question)
  end

  scenario 'Author adds file when asking question', js: :true do
    fill_in 'Your answer', with: answer.body
    attach_file 'File', "#{Rails.root}/spec/features/helper.rb"
    click_on 'Save answer'

    expect(page).to have_content I18n.t('answer.created')
    within '#answers_list' do
      expect(page).to have_link "helper.rb", href: "/uploads/attachment/file/1/helper.rb"
    end
  end
end
