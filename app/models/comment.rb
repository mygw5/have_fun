class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post_hobby
  belongs_to :parent, class_name: "Comment", foreign_key: "parent_id", optional: true

  has_many :notifications, dependent: :destroy
  has_many :replies, class_name: "Comment", foreign_key: "parent_id", dependent: :destroy

  validates :comment, presence: true
end
