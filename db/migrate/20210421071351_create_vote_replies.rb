class CreateVoteReplies < ActiveRecord::Migration[6.1]
  def change
    create_table :vote_replies do |t|
      t.references :reply, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
