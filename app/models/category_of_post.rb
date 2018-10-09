class CategoryOfPost < ApplicationRecord
  validates_uniqueness_of :post_id, :scope => :category_id

  belongs_to :category
  belongs_to :post
end
