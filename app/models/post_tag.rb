class PostTag < ApplicationRecord

  belongs_to :tag
  belongs_to :post_hobby

  validates :post_hobby_id, presence: true
  validates :tag_id,        presence: true
end
