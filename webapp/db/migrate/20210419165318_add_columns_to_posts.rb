class AddColumnsToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :author, :string
    add_column :posts, :points, :integer
  end
end
