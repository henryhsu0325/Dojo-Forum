class Api::V1::PostsController < ApplicationController
  
  # GET http://localhost:3000/api/v1/photos
  def index
    @posts = Post.all_publish(current_user)
      render json: {
        data: @posts
      }
  end

end