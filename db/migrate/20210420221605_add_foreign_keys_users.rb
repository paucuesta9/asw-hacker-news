class AddForeignKeysUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :posts, :user_id
    add_reference :posts, :user, null: false, foreign_key: true, default: 1
  end
end
