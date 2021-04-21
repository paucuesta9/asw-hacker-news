class DeleteCommentOfOfComments < ActiveRecord::Migration[6.1]
  def change
    remove_column :comments, :commentOf
    add_reference :comments, :user, null: false, foreign_key: true, default: 1
  end
end
