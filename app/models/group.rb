class Group < ApplicationRecord
  belongs_to :owner, class_name: "User"

  has_many :chats,         dependent: :destroy
  has_many :group_users,   dependent: :destroy
  has_many :users,         through:   :group_users, source: :user
  has_many :notifications, dependent: :destroy

  has_one_attached :group_image, dependent: :destroy

  validates :group_name,   length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 150 }, presence: true

  def get_group_image
    (group_image.attached?) ? group_image : "no_image.jpg"
  end

  def is_owned_by?(user)
    owner.id == user.id
  end

  def includesUser?(user)
    group_users.exists?(user_id: user.id)
  end

  def self.ransackable_attributes(auth_object = nil)
    ["group_name"]
  end

  def create_notification_by(current_user, chat_id)
    #グループメンバー検索
    group_users.each do | group_user_id |
      save_notification_chat(current_user, chat_id, group_user_id['user_id'])
    end

  end

  def save_notification_chat(current_user, chat_id, visited_id)
    notification = current_user.active_notifications.new(group_id: id, chat_id: chat_id, visited_id: visited_id, action: "chat")
    if notification.visiter_id == notification.visited_id
      notification.destroy
    end
    notification.save if notification.valid?
  end

  def create_notification_join(current_user)
    group_users.each do | group_user_id |
      save_notification_join(current_user, group_user_id['user_id'])
    end
  end

  def save_notification_join(current_user, visited_id)
    notification = current_user.active_notifications.new(group_id: id, visited_id: visited_id, action: "participation")
    if notification.visiter_id == notification.visited_id
      notification.destroy
    end
    notification.save if notification.valid?
  end
end
