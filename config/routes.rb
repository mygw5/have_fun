Rails.application.routes.draw do
  get 'groups/index'
  get 'groups/new'
  get 'groups/edit'
  get 'groups/show'
  get 'groups/member'
  get 'users/show'
  get 'users/edit'
  get 'users/confirm_withdraw'
  get 'post_hobbies/new'
  get 'post_hobbies/index'
  get 'post_hobbies/show'
  get 'post_hobbies/edit'
  get 'post_hobbies/drafts'
  get 'post_hobbies/favorites'
  get 'homes/top'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
