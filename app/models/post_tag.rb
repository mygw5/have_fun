class PostTag < ApplicationRecord
  
  belongs_to :tag
  belongs_to :post_hobby
  
end
