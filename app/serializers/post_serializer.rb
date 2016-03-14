class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :favorite_count, :updated_date, :creation_date, :user

  has_many :comments

  has_one :user_id

  def user
    object.user.first_name + " " + object.user.last_name
  end

  def title
    object.title.titleize
  end

  def creation_date
    object.created_at.strftime("%Y-%b-%d")
  end

  def updated_date
    object.updated_at.strftime("%Y-%b-%d")
  end

  def favorite_count
    Favorite.where(post_id: object.id).count
  end
end
