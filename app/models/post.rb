class Post < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  attr_accessor :tweet_it

  mount_uploaders :images, ImageUploader

  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :users, through: :favorites
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

  def user_full_name
    user.full_name if user
  end

  def favorite_for(user)
    favorites.find_by_user_id user
  end
end
