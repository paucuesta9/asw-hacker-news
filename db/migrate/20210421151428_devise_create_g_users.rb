# frozen_string_literal: true

class DeviseCreateGUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :g_users do |t|
      t.string :email, null: false
      t.string :full_name
      t.string :uid
      t.string :avatar_url

      t.timestamps null: false
    end

    add_index :g_users, :email, unique: true
  end
end
