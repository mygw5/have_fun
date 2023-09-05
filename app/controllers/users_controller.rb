class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :ensure_guest_user, only: [:edit]
  before_action :if_not_admin, only: [:index]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @post_hobbies = @user.post_hobbies
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "ユーザー情報の更新に成功しました"
      redirect_to user_path(@user)
    else
      flash.now[:alert] = "ユーザー情報の更新に失敗しました"
      render :edit
    end
  end

  def confirm_withdraw

  end

  def withdraw
    if current_user.update(is_status: false)
      reset_session
      flash[:notice] = "退会処理が完了しました"
      redirect_to root_path
    else
      flash.now[:alert] = "退会処理に失敗しました"
      render :confirm_withdraw
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :hobby, :profile_image, :is_deleted)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user || current_user.admin?
      redirect_to user_path(current_user)
    end
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.guest_user?
      flash.now[:alert] = "ゲストユーザーはプロフィール編集画面へ遷移できません"
      redirect_to user_path(current_user)
    end
  end

  def guest_user?
    email == GUEST_USER_EMAIL
  end

  def if_not_admin
    redirect_to user_path(current_user) unless current_user.admin?
  end

end
