class GroupUsersController < ApplicationController
  before_action :authenticate_user!

  def create
    @group = Group.find(params[:group_id])
    @group_user = current_user.group_users.new(group_id: params[:group_id])
    @group_user.save
    @group.create_notification_join(current_user)
    redirect_to request.referer
  end

  def destroy
    group_user = current_user.group_users.find_by(group_id: params[:group_id])
    group_user.destroy
    redirect_to request.referer
  end
end
