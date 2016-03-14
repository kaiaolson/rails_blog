namespace :send_posts do
  desc "Send a list of the top ten commented posts to every admin"
  task top_ten: :environment do
    TopTenCommentedPostsJob.perform_now()
    print "I'm in the rake task!"
  end

end
