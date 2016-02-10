class Post < ActiveRecord::Base
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
end
