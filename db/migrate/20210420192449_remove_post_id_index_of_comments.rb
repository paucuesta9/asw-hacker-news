class RemovePostIdIndexOfComments < ActiveRecord::Migration[6.1]
  def change
    remove_index :comments, name: "index_comments_on_post_id"
    add_reference :comments, :post, null: false, foreign_key: true, default: 1
  end
end
