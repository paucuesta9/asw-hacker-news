class AddTypePostToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :typePost, :string
  end
end
