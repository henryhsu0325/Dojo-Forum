class Post < ApplicationRecord
  mount_uploader :image, PhotoUploader
  
  # validates_presence_of :title, :description
  validates_inclusion_of :permit, :in => ["all", "friend", "myself"]
  validates_inclusion_of :status, :in => ["publish", "draft"]

  belongs_to :user

  has_many :categories

  has_many :category_of_posts, dependent: :destroy
  has_many :categories, through: :category_of_posts

  has_many :replies, dependent: :destroy

  has_many :vieweds, dependent: :destroy

  has_many :collects, dependent: :destroy
  has_many :collected_users, through: :collects, source: :user

  def self.all_publish
    where( :status => 'publish', :permit => 'all').all
  end

  def self.publishs
    where( :status => 'publish').all
  end 

  def self.drafts
    where( :status => 'draft').all
  end

  def collected? (user)
    self.collected_users.include?(user)
  end

  def last_replied_at
    self.replies.first.created_at.to_date
  end

end
