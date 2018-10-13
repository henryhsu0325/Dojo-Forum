class User < ApplicationRecord
  mount_uploader :avatar, PhotoUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  before_create :generate_authentication_token       

  has_many :posts, dependent: :destroy

  has_many :replies, dependent: :restrict_with_error
  has_many :replied_posts, through: :replies, source: :post

  has_many :vieweds, dependent: :restrict_with_error
  has_many :viewed_posts, through: :vieweds, source: :post

  has_many :collects, dependent: :destroy
  has_many :collected_posts, through: :collects, source: :post

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  has_many :connect_friendships, -> {where status: 'connect'}, class_name: "Friendship", dependent: :destroy
  has_many :connect_friends, through: :connect_friendships, source: :friend

  has_many :beconnect_friendships, -> {where status: 'connect'}, class_name: "Friendship", foreign_key: "friend_id"
  has_many :beconnect_friends, through: :beconnect_friendships, source: :user

  has_many :wait_friendships, -> {where status: 'send'}, class_name: "Friendship", dependent: :destroy
  has_many :wait_friends, through: :wait_friendships, source: :friend
  
  has_many :unconfirm_friendships, -> {where status: 'send'}, class_name: "Friendship", foreign_key: "friend_id"
  has_many :unconfirm_friends, through: :unconfirm_friendships, source: :user

  def admin?
    self.role == "admin"
  end
  
  def add_friend?(user) # <% if current_user.friend?(user) %>
    self.friends.include?(user)
  end

  def beconnect_friends_ids(user) 
    self.beconnect_friends.ids
  end

  def all_friends
    self.connect_friends.all.uniq
  end

  def generate_authentication_token
    # Devise.friendly_token 會自動產生 20 字元長的亂數
    self.authentication_token = Devise.friendly_token
  end

end