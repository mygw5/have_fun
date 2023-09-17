class Users::SessionsController < ApplicationController
  def guest_sign_in
    user = User.guest
    sign_in user
    flash[:notice] = "ゲストユーザーでログインしました"
    redirect_to mypage_users_path
  end
end
