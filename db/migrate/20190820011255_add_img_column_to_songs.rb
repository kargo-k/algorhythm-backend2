class AddImgColumnToSongs < ActiveRecord::Migration[5.2]
  def change
    add_column :songs, :img, :string
  end
end
