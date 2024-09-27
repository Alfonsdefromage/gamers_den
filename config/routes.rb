Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :games, only: [:new, :create, :show, :index] do
    resources :bookmarks, only: [:new, :create, :destroy]

  end

  resources :lists, only: [:new, :create, :show, :index]
  get 'wishlist', to: 'lists#wishlist', as: :wishlist
end
