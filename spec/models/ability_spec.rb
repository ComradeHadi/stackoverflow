require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'Guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'Admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'User' do
    let(:user) { create :user }
    let(:his_question) { create :question, user: user }
    let(:other_question) { create :question }
    let(:his_answer) { create :answer, user: user }
    let(:other_answer) { create :answer }
    let(:answer_in_his_question) { create :answer, question: his_question }
    let(:his_comment) { create :comment, user: user }
    let(:other_comment) { create :comment }
    let(:his_attachment) { create :attachment, attachable: his_question }
    let(:other_attachment) { create :attachment, attachable: other_question }
    let(:voted_question) { other_question.liked_by(user) }
    let(:voted_answer) { other_answer.liked_by(user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :modify, his_question }
    it { should_not be_able_to :modify, other_question }

    it { should be_able_to :create, Answer }
    it { should be_able_to :modify, his_answer }
    it { should_not be_able_to :modify, other_answer }

    it { should be_able_to :accept_as_best, answer_in_his_question }
    it { should_not be_able_to :accept_as_best, other_answer }

    it { should be_able_to :create, Comment }
    it { should be_able_to :destroy, his_comment }
    it { should_not be_able_to :destroy, other_comment }

    it { should be_able_to :create, Attachment }
    it { should be_able_to :destroy, his_attachment }
    it { should_not be_able_to :destroy, other_attachment }

    it { should be_able_to :vote, other_question }
    it { should_not be_able_to :vote, his_question }
    it { should_not be_able_to :vote, voted_question }

    it { should be_able_to :vote, other_answer }
    it { should_not be_able_to :vote, his_answer }
    it { should_not be_able_to :vote, voted_answer }

    it { should be_able_to :withdraw_vote, voted_question }
    it { should be_able_to :withdraw_vote, voted_answer }
  end
end
