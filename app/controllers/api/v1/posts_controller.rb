class Api::V1::PostsController < ApplicationController
  def index
    @posts = Post.order("created_at DESC").limit(10)
    render json: @posts
  end

  def show
    @post = Post.friendly.find params[:id]
    render json: @post
  end

  def create
    post_params = params.require(:post).permit(:title, :body)
    @post = Post.new post_params
    @post.user = @user
    if @post.save
      head :ok
    else
      render json: { errors: @post.errors.full_messages }
    end
  end
end
