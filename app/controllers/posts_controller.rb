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
    @post = Post.new(post_params)
    @post.user = current_user
    if params[:commit] == "Submit"
      @post.status = 'publish'
      if @post.save
        create_categories
        redirect_to post_path(@post)
      else
        render :new
      end
    elsif params[:commit] == "Save Draft"
      @post.status = 'draft'
      if @post.save
        create_categories
        redirect_to drafts_user_path(@post.user)
      else
        render :new
      end
    end
  end

  def edit
    @categories = Category.all
    @category = @post.categories.ids
    unless @post.user == current_user
      redirect_to user_path(@post.user)
    end
  end

  def update
    if params[:commit] == "Submit"
      @post.status = 'publish'
      if @post.update(post_params)
        create_categories
        flash[:notice] = "post was successfully updated"      
        redirect_to post_path(@post)
      else
        flash.now[:alert] = "post was failed to update"
        render :edit
      end
    elsif params[:commit] == "Save Draft"
      if @post.update(post_params)
        create_categories
        flash[:notice] = "draft was successfully updated"      
        redirect_to drafts_user_path(@post.user)
      else
        flash.now[:alert] = "draft was failed to update"
        render :edit
      end
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
 
  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :description, :permit, :image)
  end

  def create_categories
    if params["categories"].present?
      params["categories"].each do |key, value|
        if value == {"category_of_post_ids"=>"1"}
          @post.category_of_posts.create(category_id: key)
        end
      end
    end
  end

end