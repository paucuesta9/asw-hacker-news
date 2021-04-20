class AddForeignKeys < ActiveRecord::Migration[6.1]
  def change
    add_index :comments, :post_id
  end
end
