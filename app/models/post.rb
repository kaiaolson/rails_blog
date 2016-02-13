class Post < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  belongs_to :category
  belongs_to :user
  paginates_per 10

  validates :title, presence: true, uniqueness: true, length: {minimum: 7}
  validates :body, presence: true

  def self.search(term)
    where("title || body ILIKE ?","%#{term}%")
  end

  def body_snippet
    if body.length < 100
      body
    else
      "#{body[0..96]}..."
    end
  end

  def category_title
    category.title if category
  end
end
