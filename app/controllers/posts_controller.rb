class PostsController < ApplicationController
  before_action :find_post, only: [:edit, :update, :destroy]
  before_action :authenticate_user, except: [:index, :show]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new post_params
    @post.user = current_user
    if @post.save
      redirect_to post_path(@post)
      flash[:notice] = "Post created!"
    else
      render :new
      flash[:alert] = "Post not created!"
    end
  end

  def show
    @post = Post.find params[:id]
    @comment = Comment.new
  end

  def index
    if params[:q]
      session[:q] = params[:q]
      @posts = Post.search(session[:q]).order("updated_at DESC").page params[:page]
    elsif params[:all] == "all"
      @posts = Post.order("updated_at DESC").page params[:page]
    elsif params[:all] == "user"
      @posts = Post.where(user_id: current_user.id).order("updated_at DESC").page params[:page]
    else
      @posts = Post.order("updated_at DESC").page params[:page]
    end
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

  private

  def post_params
    params.require(:post).permit(:title, :body, :category_id)
  end

  def find_post
    @post = Post.find params[:id]
  end

  def authorize_user
    unless can? :manage, @post
      redirect_to root_path, alert: "access denied!"
    end
  end
end
