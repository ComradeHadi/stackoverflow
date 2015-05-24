Rails.application.routes.draw do
  use_doorkeeper

  devise_for :users, controllers: {
    registrations: 'registrations',
    omniauth_callbacks: 'omniauth_callbacks'
  }

  root to: "questions#index"

  concern :votable do
    member do
      patch :like
      patch :dislike
      patch :withdraw_vote
    end
  end

  resources :questions, except: [:edit], concerns: :votable do
    resources :answers, only: [:create, :update, :destroy], shallow: true, concerns: :votable
    resources :comments, only: :create, defaults: { commentable: 'question' }
    resources :question_subscriptions, only: [:create, :destroy], shallow: true
  end

  resources :answers, only: [] do
    resources :comments, only: :create, defaults: { commentable: 'answer' }
    patch :accept_as_best, on: :member
  end

  resources :attachments, only: [:destroy]

  resources :comments, only: [:destroy]

  resources :identities, only: :show do
    get :confirm, on: :collection
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end

      resources :questions, only: [:index, :show, :create] do
        resources :answers, only: [:index, :show, :create], shallow: true
      end
    end
  end
end
