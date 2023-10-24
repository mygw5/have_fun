class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :set_group, only: [:show, :edit, :update]
  before_action :authority_member, only: [:posts]

  def index
    @q = Group.ransack(params[:q])
    @groups = @q.result(distinct: true).page(params[:page])
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.users << @group.owner
    if group_params[:group_image].present?
      if result
        if @group.save
          flash[:notice] = "グループ作成に成功しました"
          redirect_to groups_path
        else
          flash.now[:alert] = "グループ作成に失敗しました"
          render :new
        end
      else
        flash.now[:alert] = "画像が不適切です"
        render :new
      end
    else
      if @group.save
        flash[:notice] = "グループ作成に成功しました"
        redirect_to groups_path
      else
        flash.now[:alert] = "グループ作成に失敗しました"
        render :new
      end
    end
  end

  def edit
  end

  def update
    if group_params[:group_image].present?
      if result
        if @group.update(group_params)
          flash[:notice] = "グループ情報を更新しました"
          redirect_to group_path(@group)
        else
          flash.now[:alert] = "グループ編集に失敗しました"
          render :edit
        end
      else
        flash.now[:alert] = "画像が不適切です"
        render :edit
      end
    else
      if @group.update(group_params)
        flash[:notice] = "グループ情報を更新しました"
        redirect_to group_path(@group)
      else
        flash.now[:alert] = "グループ編集に失敗しました"
        render :edit
      end
    end
  end

  def show
    @user = @group.owner
    @chat = Chat.new
  end

  def member
    @group = Group.find(params[:group_id])
    @members = @group.users
    @owner = @group.owner
  end

  def posts
    group = Group.find(params[:group_id])
    @post_hobbies = PostHobby.where(user_id: group.user_ids, post_status: :published).order(created_at: :desc)
  end

  private
    def group_params
      params.require(:group).permit(:group_name, :introduction, :group_image).merge(owner_id: current_user.id)
    end

    def ensure_correct_user
      @group = Group.find(params[:id])
      unless @group.owner_id == current_user.id
        redirect_to groups_path
      end
    end

    def set_group
      @group = Group.find(params[:id])
    end

    def result
      Vision.image_analysis(group_params[:group_image])
    end

    def authority_member
      @group = Group.find(params[:group_id])
      unless @group.includesUser?(current_user)
        redirect_to group_path(@group)
      end
    end
end
