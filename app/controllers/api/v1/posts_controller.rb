class Api::V1::PostsController < ApplicationController
  
  # GET http://localhost:3000/api/v1/posts
  def index
    @posts = Post.all_publish(current_user)
      render json: {
        data: @posts
      }
  end

  # GET http://localhost:3000/api/v1/posts/:id
  def show
    @post = Post.find_by(id: params[:id])
    if !@post
      render json: {
        message: "Can't find the post!",
        status: 400
      }
    else
      render json: {
        data: @post
      }
    end
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      render json: {
        message: "Post created successfully!",
        result: @post
      }
    else
      render json: {
        errors: @post.errors
      }
    end
  end

  private

  def post_params
    params.permit(:title, :description, :permit, :image, :status)
  end

end