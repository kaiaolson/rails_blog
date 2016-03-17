class AddImagesToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :images, :string, array: true, default: []
  end
end
