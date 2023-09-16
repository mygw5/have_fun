class NotificationsController < ApplicationController

  def index
    @notifications = current_user.passive_notifications
    #未読の通知を取り出し、既読にする
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end

  def destroy
    @notifications = current_user.passive_notifications.destroy_all
    redirect_to notifications_path
  end
end
