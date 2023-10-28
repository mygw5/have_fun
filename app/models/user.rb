class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :post_hobbies
  has_many :comments,    dependent: :destroy
  has_many :favorites,   dependent: :destroy
  has_many :group_users, dependent: :destroy
  has_many :chats,       dependent: :destroy

  has_many :active_notifications, class_name: "Notification", foreign_key: "visiter_id", dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: "visited_id", dependent: :destroy
  # 被フォロー側の関係性
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower

  # 与フォロー側の関係性
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed

  has_one_attached :profile_image

  validates :name,         length: { minimum: 1, maximum: 20 }, uniqueness: true
  validates :hobby,        length: { maximum: 50 }
  validates :introduction, length: { maximum: 100 }


  # ゲストログイン
  GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.name = "ゲスト"
      user.password = SecureRandom.urlsafe_base64
    end
  end

  def guest_user?
    email == GUEST_USER_EMAIL
  end

  def get_profile_image
    (profile_image.attached?) ? profile_image : "no_image.jpg"
  end

  def active_for_authentication?
    super && (is_status == true)
  end

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end

  def follow(user)
    relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

end
