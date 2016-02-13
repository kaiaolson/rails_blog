class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  paginates_per 50
  validates :body, presence: true, uniqueness: {scope: :post_id}
end
