class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
    @q = Group.ransack(params[:q])
    @groups = @q.result(distinct: true).page(params[:page])
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.create(group_params.merge(owner_id: current_user.id))
    @group.users << current_user
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
      redirect_to group_path(@group)
    else
      flash.now[:alert] ="グループ編集に失敗しました"
      render :edit
    end
  end

  def show
    @group = Group.find(params[:id])
    @user = @group.owner
    @chat = Chat.new
  end

  def member
   @group = Group.find(params[:group_id])
   @members = @group.users.page(params[:page])
   @owner = @group.owner
  end

  private

  def group_params
    params.require(:group).permit(:group_name, :introduction, :group_image)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end

end
