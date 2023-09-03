class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :post_hobby
  
  validates  :comment, presence: true

end
