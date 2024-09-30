Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :games, only: [:new, :create, :show, :index] do
    resources :bookmarks, only: [:new, :create, :destroy]

  end

  resources :lists, only: [:new, :create, :show, :index]
  get 'wishlist', to: 'lists#wishlist', as: :wishlist
  post 'replace_button', to: 'lists#replace_button', as: :replace_button

  resources :bookmarks, only: [:new, :create, :destroy]
  patch 'move_to_owned', to: 'bookmarks#move_to_owned', as: :move_to_owned
end
