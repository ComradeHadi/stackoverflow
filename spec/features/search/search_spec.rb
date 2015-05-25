require 'features/helper'

feature 'Search for information', %q(
  As a guest or user
  I want to be able to search for information
) do
  given!(:question1) { create :question, title: 'Question sample title', body: 'Body content' }
  given!(:question2) { create :question, title: 'Another question', body: 'sphinx content' }
  given!(:answer1) { create :answer, question: question1, body: 'First sample answer' }
  given!(:answer2) { create :answer, question: question1, body: 'Second reply' }
  given!(:comment1) { create :comment, commentable: question1, body: 'Clever comment' }
  given!(:comment2) { create :comment, commentable: answer2, body: 'Nothing clever' }

  scenario "Searching for questions, including associations", js: true do
    ThinkingSphinx::Test.run do
      visit questions_path

      within "#search" do
        fill_in 'query', with: answer1.body
        select 'questions, including all associations', from: 'search_option'
        click_on 'Search'
      end

      expect(page).to have_content 'Search results'
      expect(page).to have_content question1.title
      expect(page).to_not have_content question2.title
      expect(page).to_not have_content answer1.body
    end
  end

  scenario "Searching for all objects", js: true do
    ThinkingSphinx::Test.run do
      visit questions_path

      within "#search" do
        fill_in 'query', with: 'sample'
        select 'all objects', from: 'search_option'
        click_on 'Search'
      end

      expect(page).to have_content 'Search results'
      expect(page).to have_content question1.title
      expect(page).to have_content answer1.body
    end
  end

  scenario "Searching for only questions", js: true do
    ThinkingSphinx::Test.run do
      visit questions_path

      within "#search" do
        fill_in 'query', with: 'content'
        select 'only questions', from: 'search_option'
        click_on 'Search'
      end

      expect(page).to have_content 'Search results'
      expect(page).to have_content question1.title
      expect(page).to have_content question2.title
    end
  end

  scenario "Searching for only answers", js: true do
    ThinkingSphinx::Test.run do
      visit questions_path

      within "#search" do
        fill_in 'query', with: 'reply'
        select 'only answers', from: 'search_option'
        click_on 'Search'
      end

      expect(page).to have_content 'Search results'
      expect(page).to have_content answer2.body
      expect(page).to_not have_content answer1.body
    end
  end

  scenario "Searching for only comments", js: true do
    ThinkingSphinx::Test.run do
      visit questions_path

      within "#search" do
        fill_in 'query', with: 'clever'
        select 'only comments', from: 'search_option'
        click_on 'Search'
      end

      expect(page).to have_content 'Search results'
      expect(page).to have_content comment1.body
      expect(page).to have_content comment2.body
    end
  end

  scenario "Searching for only users", js: true do
    ThinkingSphinx::Test.run do
      visit questions_path

      within "#search" do
        fill_in 'query', with: question1.author.email
        select 'only users', from: 'search_option'
        click_on 'Search'
      end

      expect(page).to have_content 'Search results'
      expect(page).to have_content question1.author.user_name
    end
  end
end
