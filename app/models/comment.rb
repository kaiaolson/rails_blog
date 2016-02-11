class Comment < ActiveRecord::Base
  belongs_to :product
  paginates_per 50
  validates :body, presence: true, uniqueness: {scope: :post_id}
end
