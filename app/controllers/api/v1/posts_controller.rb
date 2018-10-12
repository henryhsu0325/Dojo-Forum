class Api::V1::PostsController < ApiController
  before_action :authenticate_user!, except: :index

  # GET http://localhost:3000/api/v1/posts
  def index
    @posts = Post.all
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
      title: @post.title,
      description: @post.description
    }
    end
  end
  
   # POST http://localhost:3000/api/v1/posts/
  def create
    @post = Post.new(post_params)

    if @post.save
      render json: {
        message: "Post was created successfully!",
        result: @post
      }
    else
      render json: {
        errors: @post.errors
      }
    end
  end

  # PATCH http://localhost:3000/api/v1/posts/:id
  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      render json: {
        message: "Post was updated successfully!",
        result: @post
      }
    else
      render json: {
        errors: @post.errors
      }
    end
  end

  # DELETE http://localhost:3000/api/v1/posts/:id
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    render json: {
      message: "Post destroy seccessfully!"
    }
  end
  
  private

  def post_params
    params.permit(:title, :description, :permit, :image, :status)
  end

end