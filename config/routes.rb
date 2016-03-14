Rails.application.routes.draw do

  get 'password_resets/new'

  get "/about" => "home#about"
  get "/home" => "home#index"
  get "/posts/search" => "posts#search"
  # get "/sessions/forgot_password" => "sessions#forgot_password"

  resources :posts do
    resources :comments, only: [:index, :create, :destroy]
    # get "/comments/:id" => "posts#show"
    # post "/" => "posts#index", on: :collection
    resources :favorites, only: [:create, :destroy]
  end
  resources :favorites, only: [:index]
  resources :comments, only: [:edit, :update]

  resources :users, only: [:new, :create, :edit, :update, :show] do
    get "/change_password" => "users#change_password"
  end
  resources :sessions, only: [:new, :create, :destroy] do
    delete :destroy, on: :collection
    get :forgot_password, on: :collection
  end

  resources :password_resets

  root "home#index"
end
