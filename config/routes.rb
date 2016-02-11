Rails.application.routes.draw do

  get "/about" => "home#about"
  get "/home" => "home#index"
  get "/posts/search" => "posts#search"

  resources :posts do
    resources :comments, only: [:create, :destroy]
  end
  resources :comments

  root "home#index"
end
