class PostHobby < ApplicationRecord
  belongs_to :user

  has_many :comments,      dependent: :destroy
  has_many :favorites,     dependent: :destroy
  has_many :post_tags,     dependent: :destroy
  has_many :tags,          through:   :post_tags
  has_many :notifications, dependent: :destroy

  has_one_attached :post_image, dependent: :destroy

  with_options presence: true, if: :published? do
    validates  :title, length: { maximum: 20 }
    validates  :text,  length: { maximum: 300 }
  end

  enum post_status: { published: 0, draft: 1, unpublished: 2 }


  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end


  def save_tags(sent_tags)
    current_tags = self.tags.pluck(:tag_name) unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(tag_name: old_name)
    end

    new_tags.each do |new_name|
      post_tag = Tag.find_or_create_by(tag_name: new_name)
      self.tags << post_tag
    end
  end

  def get_post_image
    (post_image.attached?) ? post_image : "no_image.jpg"
  end

  def self.ransackable_associations(auth_object = nil)
    ["tags"] # アソシエーション先を記述
  end

  def self.ransackable_attributes(auth_object = nil)
    ["title"]
  end

  def create_notification_by(current_user, comment_id)
    #自分以外のコメントしている人を全て取得し、全員に通知を送る
    comment_user_ids = Comment.select(:user_id).where(post_hobby_id: id).where.not(user_id: current_user.id).distinct

    comment_user_ids.each do | comment_user_id |
      save_notification_comment(current_user, comment_id, comment_user_id['user_id'])
    end
    #投稿者には全て通知を送る
    save_notification_comment(current_user, comment_id, user_id)
  end

  def save_notification_comment(current_user, comment_id, visited_id)
    #コメントする度に通知を作成する
    notification = current_user.active_notifications.new(post_hobby_id: id, comment_id: comment_id, visited_id: visited_id, action: "comment")
    # 自分のコメント通知は確認済みにする
    if notification.visiter_id == notification.visited_id
      notification.destroy
    end
    notification.save if notification.valid?
  end

  def save_draft
    self.post_status = :draft
    save
  end

end
