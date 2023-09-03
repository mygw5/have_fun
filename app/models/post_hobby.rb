class PostHobby < ApplicationRecord

  belongs_to  :user

  has_many  :comments,  dependent: :destroy
  has_many  :favorites, dependent: :destroy
  has_many  :post_tags, dependent: :destroy
  has_many  :tags,      through:   :post_tags

  has_one_attached :post_image, dependent: :destroy

  validates  :title, presence: true
  validates  :text,  presence: true, length:{ maximum:200 }

  enum post_status: { published: 0, draft: 1, unpublished: 2 }

  def save_draft
    self.post_status = :draft
    save(validate: false)
  end

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end


  def save_tags(sent_tags)
    current_tags = self.tags.pluck(:tag_name) unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(tag_name:old_name)
    end

    new_tags.each do |new_name|
      tag = Tag.find_or_create_by(tag_name:new_name)
      self.tags << tag
    end
  end

  def get_post_image
    (post_image.attached?) ? post_image : 'no_image.jpg'
  end
end
