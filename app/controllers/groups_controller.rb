class GroupsController < ApplicationController
  def index
    @q = Group.ransack(params[:q])
    @group = Group.result(distinct: true)
  end

  def new
    @group = Group.new
  end

  def create

  end

  def edit
    @group = Group.find(params[:id])
  end

  def update

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
