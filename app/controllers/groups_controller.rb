class GroupsController < ApplicationController
  def index
    @q = Group.ransack(params[:q])
    @group = Group.result(distinct: true)
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.create(group_params)
    if @group.save
      flash[:notice] = "グループ作成に成功しました"
      redirect_to groups_path
    else
      flash.now[:alert] = "グループ作成に失敗しました"
      render :new
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      flash[:notice] = "グループ情報を更新しました"
    else
      flash.now[:alert]
      render :edit
    end
  end

  def show
    @group = Group.find(params[:id])
  end

  def member
  end

  private

  def group_params
    params.require(:group).permit(:group_name, :introduction, :group_image)
  end


end
