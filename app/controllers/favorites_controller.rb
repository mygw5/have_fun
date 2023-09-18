class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    post_hobby = PostHobby.find(params[:post_hobby_id])
    @favorite = current_user.favorites.new(post_hobby_id: post_hobby.id)
    @favorite.save
    render "replace_btn"
  end

  def destroy
    post_hobby = PostHobby.find(params[:post_hobby_id])
    @favorite = current_user.favorites.find_by(post_hobby_id: post_hobby.id)
    @favorite.destroy
    render "replace_btn"
  end
end
