Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :games, only: [:new, :create, :show, :index] do
    resources :bookmarks, only: [:new, :create]
  end

  resources :lists, only: [:new, :create, :show, :index]

  resources :bookmarks, only: [:update, :destroy]
  post 'replace_button', to: 'bookmarks#replace_button', as: :replace_button
  get 'wishlist', to: 'bookmarks#wishlist_index', as: :wishlist
  patch 'move_to_owned', to: 'bookmarks#move_to_owned', as: :move_to_owned
  patch "wishlist_update", to: "bookmarks#wishlist_update", as: :wishlist_update
end
