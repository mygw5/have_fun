class FavoritesController < ApplicationController
  def create
    @post_hobby = PostHobby.find(params[:post_hobby_id])
    favorite = current_user.favorites.new(post_hobby_id: @post_hobby.id)
    favorite.save
    redirect_to post_hobby_path(@post_hobby)
  end

  def destroy
    @post_hobby = PostHobby.find(params[:post_hobby_id])
    favorite = current_user.favorites.find_by(post_hobby_id: @post_hobby.id)
    favorite.destroy
    redirect_to post_hobby_path(@post_hobby)
  end
end
