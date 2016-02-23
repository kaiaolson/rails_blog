class TopTenCommentedPostsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    post_ids = Comment.where("updated_at >= ?", 1.month.ago).
                       select("post_id").
                       group(:post_id).
                       order("count(post_id) DESC").
                       limit(10).
                       to_a
    admins = User.where("admin = ?", true)
    posts = post_ids.map  do |comment|
      Post.find comment.post_id
    end
    admins.each do |admin|
      PostsMailer.send_top_commented_posts(posts, admin.id).deliver_now
    end
    print "I'm in the Job!"
  end
end
