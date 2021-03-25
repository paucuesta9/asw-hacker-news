class AddDefault0PointsToPosts < ActiveRecord::Migration[6.1]
  def change
    change_column_default :posts, :points, to: 0
  end
end
