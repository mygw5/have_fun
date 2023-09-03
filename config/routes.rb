Rails.application.routes.draw do
<<<<<<< HEAD
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
=======

  devise_for   :users

  devise_scope :user do
    post 'users/guest_sign_in', to: "users/sessions#guest_sign_in"
  end

  root to: "homes#top"

  resources :post_hobbies do
    get "drafts",         on: :collection
    get :favorites,       on: :collection
    resources :comments,  only: [:create]
    resources :favorites, only: [:create, :destroy]
  end

  resources :users,       only: [:show, :edit, :update] do
    get   "confirm_withdraw"
    patch "withdraw"
  end

  resources :groups, only: [:new, :create, :index, :show, :edit, :update] do
    get "group_member"
    resources :group_users, only: [:create, :destroy]
    resources :chats, only: [:create]
  end
>>>>>>> origin/develop
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
