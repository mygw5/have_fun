class Tag < ApplicationRecord

  has_many :post_tags, dependent: :destroy, foreign_key: 'tag_id'
  has_many :post_hobbies, through: :post_tags

  validates  :tag_name, presence: true, uniqueness: true

  scope :merge_post_hobbies, -> (tags){ }

  def self.ransackable_associations(auth_object = nil)
    ["post_hobbies"] #アソシエーション先を記述
  end

  def self.ransackable_attributes(auth_object = nil)
    ["id"]
  end

end
