class CreateVoteComments < ActiveRecord::Migration[6.1]
  def change
    create_table :vote_comments do |t|
      t.references :comment, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
