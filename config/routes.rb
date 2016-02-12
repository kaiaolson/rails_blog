Rails.application.routes.draw do

  get "/about" => "home#about"
  get "/home" => "home#index"
  get "/posts/search" => "posts#search"
  get "/users/change_password" => "users#change_password"

  resources :posts do
    resources :comments, only: [:create, :destroy]
  end
  resources :comments

  resources :users, only: [:new, :create, :edit, :update, :show]
  resources :sessions, only: [:new, :create, :destroy] do
    delete :destroy, on: :collection
  end
  root "home#index"
end
