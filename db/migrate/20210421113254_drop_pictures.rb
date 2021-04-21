class DropPictures < ActiveRecord::Migration[6.1]
  def change
    drop_table :pictures
  end
end
