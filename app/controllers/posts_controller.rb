class PostsController < ApplicationController
  before_action :authenticate_user!, except: :index  

  def index
    @posts = Post.all_publish.page(params[:page]).per(10)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params) 
    if params[:commit] == "Submit"
      @post.status = 'publish'
      if @post.save
        redirect_to post_path(@post)
      else
        render :new
      end
      elsif params[:commit] == "draft"
        @post.status = 'draft'
      if @post.save
        redirect_to draft_user_path(@post)
      else
        render :new
      end
    end
  end

  def feed
  end

  def post_params
    params.require(:post).permit(:title, :description, :permit, :image)
  end

end
