class AddPointsAndTypeToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :points, :integer
    add_column :posts, :type, :string
  end
end
