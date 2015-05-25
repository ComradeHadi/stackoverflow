class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      if user.admin?
        admin_abilities
      else
        user_abilities
      end
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all

    can :search, Search
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    alias_action :update, :destroy, to: :modify
    alias_action :like, :dislike, to: :vote

    can :create, [Question, Answer]
    can :modify, [Question, Answer], &method(:author_of?)
    can :accept_as_best, Answer do |answer|
      @user.author_of? answer.question
    end

    can :create, Comment
    can :destroy, Comment, &method(:author_of?)

    can :create, Attachment
    can :destroy, Attachment do |attachment|
      @user.author_of? attachment.attachable
    end

    can :vote, votables do |votable|
      !(author_of? votable) && !(votable.voted_by? @user)
    end
    can :withdraw_vote, votables do |votable|
      votable.voted_by? @user
    end

    can :create, QuestionSubscription
    can :destroy, QuestionSubscription do |subscription|
      @user.author_of? subscription
    end
  end

  private

  def votables
    [Question, Answer]
  end

  def author_of?(resource)
    @user.author_of? resource
  end
end
