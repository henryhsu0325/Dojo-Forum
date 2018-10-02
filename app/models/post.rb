class Post < ApplicationRecord
  mount_uploader :image, PhotoUploader
  validates_inclusion_of :permit, :in => ["all", "friend", "myself"]
  validates_inclusion_of :status, :in => ["publish", "draft"]

  belongs_to :user

  has_many :categories

  def self.all_publish
    where( :status => 'publish', :permit => 'all').all
  end
  
end
