# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

author = FactoryGirl.create(:user, email: 'anatoly.cmdx@gmail.com', password: 'password')
question = FactoryGirl.create(:question, user: author)
answers  = FactoryGirl.create_list(:answer, 2, question: question)
FactoryGirl.create(:comment, body: Faker::Lorem.paragraph, commentable: question)
FactoryGirl.create(:comment, body: Faker::Lorem.paragraph, commentable: question)
FactoryGirl.create(:comment, body: Faker::Lorem.paragraph, commentable: answers.at(0))
FactoryGirl.create(:comment, body: Faker::Lorem.paragraph, commentable: answers.at(1))
