class Post < ApplicationRecord
  mount_uploader :image, PhotoUploader

  belongs_to :user

  has_many :categories

  def self.all_publish
    where( :status => 'publish', :permit => 'all').all
  end
  
end
