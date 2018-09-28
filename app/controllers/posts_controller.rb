class PostsController < ApplicationController
  before_action :authenticate_user!, except: :index  

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def feed
  end

  def post_params
    params.require(:post).permit(:title, :description, :image)
  end

end
