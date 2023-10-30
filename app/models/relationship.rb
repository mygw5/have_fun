class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  def create_notification_by(current_user, comment_id)
    # コメントする度に通知を作成する
    notification = current_user.active_notifications.new(post_hobby_id: id, comment_id: comment_id, visited_id: user_id, action: "comment")
    # 自分のコメント通知は確認済みにする
    if notification.visiter_id == notification.visited_id
      notification.destroy
    end
    notification.save if notification.valid?
  end
end
