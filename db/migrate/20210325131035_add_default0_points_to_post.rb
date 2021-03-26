class AddDefault0PointsToPost < ActiveRecord::Migration[6.1]
  def change
    change_column :posts, :points, :integer, :default => 0
  end
end
