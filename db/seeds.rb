# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

me = FactoryGirl.create(:user, email: 'anatoly.cmdx@gmail.com', password: 'password')
other_user = FactoryGirl.create(:user)

question = FactoryGirl.create(:question, :with_files, files_count: 2, user: me)
FactoryGirl.create(:question, user: me)
FactoryGirl.create(:question, user: other_user)

answer1 = FactoryGirl.create(:answer, :with_files, files_count: 1, question: question, user: me)
answer2 = FactoryGirl.create(:answer, :with_files, files_count: 2, question: question)
answer3 = FactoryGirl.create(:answer, question: question, user: other_user)

FactoryGirl.create(:comment, commentable: question)
FactoryGirl.create(:comment, commentable: question, user: me)
FactoryGirl.create_list(:comment, 3, commentable: answer1)
FactoryGirl.create(:comment, commentable: answer2)

question.liked_by answer3.user
question.liked_by answer2.user

answer2.liked_by me
answer2.accept_as_best
answer2.liked_by other_user

answer1.liked_by other_user
