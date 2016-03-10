class CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user, except: [:index, :show]
  before_action :find_comment, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def new
    @comment = Comment.new
  end

  def create
    @post = Post.friendly.find params[:post_id]
    @comment = Comment.new comment_params
    @comment.post = @post
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        # CommentsMailer.notify_post_owner(@comment).deliver_later
        format.html { redirect_to post_path(@post), notice: "Comment created!" }
        format.js   { render :create_success }
      else
        format.html { render "/posts/show", alert: "Comment not created!" }
        format.js   { render :create_failure }
      end
    end
  end

  def show
  end

  def index
    @post = Post.friendly.find params[:post_id]
    render json: @post.comments
  end

  def edit
    respond_to do |format|
      format.js { render :edit_comment }
    end
  end

  def update
    @post = @comment.post
    respond_to do |format|
      if @comment.update comment_params
        format.html { redirect_to comment_path(@comment) }
        format.js   { render :update_success }
      else
        format.html { render :edit }
        format.js   { render :update_failure }
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to post_path(params[:post_id]), notice: "Comment deleted!" }
      format.js   { render }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_comment
    @comment = Comment.find params[:id]
  end

  def authorize_user
    unless (can? :manage, @comment) || (can? :destroy, @comment)
      redirect_to root_path, alert: "access denied!"
    end
  end
end
