namespace :send_comments do
  desc "Send daily comments summary"
  # :environment loads Rails environment, so have access to the app
  task :daily_summary => :environment do
    CommentsSummaryJob.perform_now()
  end
end
