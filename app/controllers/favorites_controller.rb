class FavoritesController < ApplicationController
  before_action :authenticate_user

  def index
    @posts = current_user.favorite_posts.page params[:page]
  end

  def create
    @post = Post.friendly.find params[:post_id]
    @favorite = Favorite.new(post: @post, user: current_user)
    respond_to do |format|
      if @favorite.save
        format.html { redirect_to @post, notice: "Post added to favorites!" }
        format.js   { render :create_success }
      else
        format.html { redirect_to @post, notice: "Post already in favorites!" }
        format.js   { render :create_failure }
      end
    end
  end

  def destroy
    @post = Post.friendly.find params[:post_id]
    @favorite = current_user.favorites.find params[:id]
    @favorite.destroy
    respond_to do |format|
      format.html { redirect_to @post, notice: "Post removed from favorites." }
      format.js   { render }
    end
  end
end
