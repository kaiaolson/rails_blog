class CommentsMailer < ApplicationMailer

  def notify_post_owner(comment)
    @user = comment.user
    @post = comment.post
    mail(to: @post.user.email, subject: "#{@user.full_name} commented on your post")
  end

  def send_daily_summary(comments, post_id)
    @post = Post.find post_id
    @post_comments = comments
    mail(to: @post.user.email, subject: "Today's comments on #{@post.title}")
  end
end
