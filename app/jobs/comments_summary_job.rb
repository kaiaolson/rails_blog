class CommentsSummaryJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    @post_ids = Comment.today.map do |comment|
      comment.post_id
    end
    @post_ids.uniq.each do |post_id|
      comments = Comment.today.where(post_id: post_id)
      CommentsMailer.send_daily_summary(comments, post_id).deliver_now
    end
  end
end
