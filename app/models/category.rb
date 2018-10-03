class Category < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :category_of_posts, dependent: :restrict_with_error
  has_many :posts, through: :category_of_posts
end
