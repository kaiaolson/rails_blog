class Comment < ActiveRecord::Base
  belongs_to :post
  paginates_per 50
  validates :body, presence: true, uniqueness: {scope: :post_id}
end
