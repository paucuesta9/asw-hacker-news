class AddIndexType < ActiveRecord::Migration[6.1]
  def change
    add_column :replies, :parent_type, :string
    add_index :replies, :parent_type
  end
end
