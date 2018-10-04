class PostsController < ApplicationController
  before_action :authenticate_user!, except: :index  
   before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.all_publish.page(params[:page]).per(20)
    @categories = Category.all
  end

  def new
    @post = Post.new
    @categories = Category.all
    @category = @post.categories.ids
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

  def show
  end

  def edit
    if @post.user == current_user
       @categories = Category.all
    else
      flash[:alert] = '沒有權限'
      redirect_back(fallback_location: root_path)
    end
  end

  def update
    if @post.update(post_params)
      if params[:commit] == 'Published' && @post.draft == true
        @post.draft = false
        @post.save
        flash[:notice] = '已成功發表'
      else
        flash[:notice] = '文章已更新'
      end
      redirect_to post_path(@post)
    else
      flash[:alert] = @post.errors.full_messages.to_sentence if @post.errors.any?
      render :edit
    end
  end

  def destroy
    if @post.user == current_user || current_user.admin?
      @post.destroy
      flash[:notice] = "Successfully deleted"
      redirect_to posts_path
    else
      flash[:alert] = '沒有權限'
      redirect_back(fallback_location: root_path)
    end
  end
  
  def feed
  end

  private 

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :description, :permit, :image)
  end

end
