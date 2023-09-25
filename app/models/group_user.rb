class GroupUser < ApplicationRecord
  belongs_to :group
  belongs_to :user

   def create_notification_by(current_user)
    notification = current_user.active_notifications.new(group_id: id, visited_id: owner_id, action: "participation")
    notification.save if notification.valid?
  end
end
