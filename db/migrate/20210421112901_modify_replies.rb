class ModifyReplies < ActiveRecord::Migration[6.1]
  def change
    drop_table :replies
    create_table :replies do |t|
      t.string :text
      t.references :parent, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
