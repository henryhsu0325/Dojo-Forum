class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :posts, :drafts]

  def show
    @posts = @user.posts.publishs
  end 

  def edit 
    unless @user == current_user
      redirect_to user_path(@user)
    end
  end

  def update
    @user.update(user_params)
    redirect_to user_path(@user)
  end

  def posts
    @posts = @user.posts.publishs
  end

  def drafts
    @drafts = @user.posts.drafts
    unless @user == current_user
      redirect_to user_path(@user)
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :introduction, :avatar)
  end

end