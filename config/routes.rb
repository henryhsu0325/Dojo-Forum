Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users, only: [:show, :edit, :update] do
    # profile/ user page
    member do
      get :posts
      get :comments
      get :collects
      get :drafts
      get :friends
    end
  end

  resources :posts do
    collection do
      get :feeds
    end
  end

  resources :categories, only: :show
  root "posts#index" 

  namespace :admin do
    resources :categories
    resources :users, only: [:index, :update]
    root "users#index"
    end 
  end