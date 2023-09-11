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

  has_one_attached :profile_image

  validates :name,  length: { minimum:1, maximum:20 }, uniqueness: true
  validates :hobby, length: { maximum:50 }


  #ゲストログイン
  GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.name = "ゲストユーザー"
      user.password = SecureRandom.urlsafe_base64
    end
  end

  def guest_user?
    email == GUEST_USER_EMAIL
  end


  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def active_for_authentication?
    super && (is_status == true)
  end

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end
end
