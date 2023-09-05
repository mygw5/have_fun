class UsersController < ApplicationController

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
    if current_user.update(is_deleted: true)
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



end
