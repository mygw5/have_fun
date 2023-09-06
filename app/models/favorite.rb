class Favorite < ApplicationRecord

  belongs_to :user
  belongs_to :post_hobby

  validates_uniqueness_of :post_hobby_id, scope: :user_id

end
