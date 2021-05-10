class CreateAll < ActiveRecord::Migration[6.1]
  def change
      create_table :users do |t|
        t.string :username
        t.string :password
  
        t.timestamps
      end
  
      create_table :posts do |t|
        t.string :title
        t.string :url
        t.string :text
        t.integer :points, :default => 0
        t.string :typePost
  
        t.timestamps
      end
  
      create_table :comments do |t|
        t.string :text
        t.integer :commentOf
  
        t.timestamps
      end
  
      add_reference :comments, :user, null: false, foreign_key: true, default: 1
      add_reference :comments, :post, null: false, foreign_key: true, default: 1
      add_reference :posts, :user, null: false, foreign_key: true, default: 1
  
      create_table :vote_posts do |t|
        t.references :post, null: false, foreign_key: true
        t.references :user, null: false, foreign_key: true
  
        t.timestamps
      end
  
      create_table :vote_comments do |t|
        t.references :comment, null: false, foreign_key: true
        t.references :user, null: false, foreign_key: true
  
        t.timestamps
      end
  
      create_table :replies do |t|
        t.string :text
        t.references :parent, polymorphic: true, null: false
        t.references :user, null: false, foreign_key: true
        t.timestamps
      end
  
      create_table :vote_replies do |t|
        t.references :reply, null: false, foreign_key: true
        t.references :user, null: false, foreign_key: true
  
        t.timestamps
      end
  
      add_column :comments, :votes, :integer, null: false, default: 0
      add_column :replies, :votes, :integer, null: false, default: 0
  
      add_column :users, :uid, :string
      add_column :users, :provider, :string
  
      add_column :users, :about, :string, :default => ''
    end
end