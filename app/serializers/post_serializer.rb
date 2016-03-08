class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :favorite_count, :updated_date, :creation_date

  has_many :comments

  def title
    object.title.titleize
  end

  def creation_date
    object.created_at.strftime("%Y-%b-%d")
  end

  def updated_date
    object.created_at.strftime("%Y-%b-%d")
  end

  def favorite_count
    Favorite.where(post_id: object.id).count
  end
end
