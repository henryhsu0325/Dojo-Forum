Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users, only: [:show, :edit, :update] do
    # profile/ user page
    member do
      get :posts
      get :replies
      get :collects
      get :drafts
      get :friends
    end
  end

  resources :posts do
    resources :replies, only: [:create, :destroy, :edit, :update]
    collection do
      get :feeds
    end
    member do
      post :collect
      post :uncollect
    end
  end

  resources :friendships, only: [:create, :destroy]

  resources :categories, only: :show
  root "posts#index" 

  namespace :admin do
    resources :categories
    resources :users, only: [:index, :update]
    root "users#index"
    end 
  end