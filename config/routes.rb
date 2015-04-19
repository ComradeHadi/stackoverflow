Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  concern :votable do
    member do
      patch :like
      patch :dislike
      patch :withdraw_vote
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, except: [:index, :show, :edit], shallow: true, concerns: :votable do
      patch :accept_as_best, on: :member
    end

    resources :comments, only: :create, defaults: {commentable: 'question'}
  end

  resources :answers do
    resources :comments, only: :create, defaults: {commentable: 'answer'}
  end

  resources :attachments, only: [:destroy]

  resources :comments, only: [:destroy]
end
