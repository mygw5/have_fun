class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :post_hobbies
  has_many :comments,    dependent: :destroy
  has_many :favorites,   dependent: :destroy
  has_many :group_users, dependent: :destroy
  has_many :chats

  has_one_attached :profile_image

  validates :name,  length: { minimum:2, maximum:20 }, uniqueness: true
  validates :hobby, length: { maximum:50 }

  #ゲストログイン

  GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end

  def guest_user?
    email == GUEST_USER_EMAIL
  end

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
end
