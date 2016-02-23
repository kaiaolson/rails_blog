class FavoritesController < ApplicationController
  before_action :authenticate_user

  def index
    @posts = current_user.favorite_posts.page params[:page]
  end

  def create
    post = Post.find params[:post_id]
    favorite = Favorite.new(post: post, user: current_user)
    if favorite.save
      redirect_to post, notice: "Post added to favorites!"
    else
      redirect_to post, notice: "Post already in favorites!"
    end
  end

  def destroy
    post = Post.find params[:post_id]
    favorite = current_user.favorites.find params[:id]
    favorite.destroy
    redirect_to post, notice: "Post removed from favorites."
  end
end
