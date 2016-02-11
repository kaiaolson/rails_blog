class PostsController < ApplicationController
  before_action :find_post, only: [:show, :edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new post_params
    if @post.save
      redirect_to post_path(@post)
      flash[:notice] = "Post created!"
    else
      render :new
      flash[:alert] = "Post not created!"
    end
  end

  def show
    @comment = Comment.new
  end

  def index
    @posts = Post.page params[:page]
  end

  def edit
  end

  def update
    if @post.update post_params
      redirect_to post_path(@post)
      flash[:notice] = "Post updated!"
    else
      render :edit
      flash[:alert] = "Post not updated!"
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path
    flash[:notice] = "Your post was deleted!"
  end

  def search
    session[:q] = params[:q]
    @results = Post.search(session[:q]).page params[:page]
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end

  def find_post
    @post = Post.find params[:id]
  end
end
