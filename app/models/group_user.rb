class GroupUser < ApplicationRecord
  belongs_to :group
  belongs_to :user

  def create_notification_by(current_user)
    notification = current_user.active_notifications.new(group_id: group.id, visited_id: group.owner_id, action: "participation")
    notification.save if notification.valid?
  end

end
