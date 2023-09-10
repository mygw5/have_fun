class Group < ApplicationRecord

  belongs_to :owner, class_name: "User"

  has_many :chats,       dependent: :destroy
  has_many :group_users, dependent: :destroy
  has_many :users,       through:   :group_users, source: :user

  has_one_attached :group_image, dependent: :destroy

  validates :group_name,   presence: true, uniqueness: true
  validates :introduction, presence: true

  def get_group_image
    (group_image.attached?) ? group_image : 'no_image.jpg'
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
end
