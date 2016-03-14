class PostsMailer < ApplicationMailer
  def send_top_commented_posts(posts, admin_id)
    @posts = posts
    @admin = User.find admin_id
    mail(to: @admin.email, subject: "Top 10 Commented Posts")
    print "I'm in the mailer!"
  end
end
