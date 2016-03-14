class PostsController < ApplicationController
  before_action :find_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user, except: [:index, :show]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new post_params
    @post.user = current_user
    if @post.save
      if @post.tweet_it === true
        client = Twitter::REST::Client.new do |config|
          config.consumer_key        = ENV["twitter_consumer_key"]
          config.consumer_secret     = ENV["twitter_consumer_secret"]
          config.access_token        = current_user.twitter_consumer_token
          config.access_token_secret = current_user.twitter_consumer_secret
        end
        client.update("#{@post.title}: http://rails-blog.herokuapp.com/#{@post.friendly_id}")
      end
      flash[:notice] = "Post created!"
      redirect_to post_path(@post)
    else
      flash[:alert] = "Post not created!"
      redirect_to new_post_path
    end
  end

  def show
    @comment = Comment.new
    comments = @post.comments
    respond_to do |format|
      format.html { render }
      format.json { render json: @post}
    end
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

    respond_to do |format|
      format.html { render }
      format.json { @posts = Post.all
                    render json: @posts.select(:id, :title, :body, :user_id, :updated_at, :created_at).limit(1) }
    end
  end

  def edit
  end

  def update
    @post.slug = nil
    if @post.update post_params
      redirect_to post_path(@post)
      flash[:notice] = "Post updated!"
    else
      flash[:alert] = "Post not updated!"
      render :edit
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = "Your post was deleted!"
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :category_id, {images: []}, :tweet_it)
  end

  def find_post
    @post = Post.friendly.find params[:id]
  end

  def authorize_user
    unless can? :manage, @post
      redirect_to root_path, alert: "access denied!"
    end
  end
end
