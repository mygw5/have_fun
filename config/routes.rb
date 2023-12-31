Rails.application.routes.draw do
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"

  devise_for   :users

  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end

  root to: "homes#top"

  resources :post_hobbies do
    get :unpublished,     on: :collection
    get :favorites,       on: :collection
    resources :comments,  only: [:create, :destroy]
    resource :favorites,  only: [:create, :destroy]
  end

  resources :users,       only: [:index, :show, :edit, :update] do
    get   :confirm_withdraw
    patch :withdraw
    get   :mypage, on: :collection
  end

  resources :groups, only: [:new, :create, :index, :show, :edit, :update] do
    get :member
    resources :group_users, only: [:create, :destroy]
    resources :chats,       only: [:create]
  end

  resources :notifications, only: [:index, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
