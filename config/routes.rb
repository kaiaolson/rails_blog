Rails.application.routes.draw do

  get "/about" => "home#about"
  get "/home" => "home#index"
  get "/search" => "home#search"

  resources :posts, only: [:new, :show, :create, :index, :edit, :update, :destroy]
  resources :comments

  root "home#index"
end
