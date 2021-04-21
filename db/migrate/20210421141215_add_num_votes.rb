class AddNumVotes < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :votes, :integer, null: false, default: 0
    add_column :replies, :votes, :integer, null: false, default: 0
  end
end
