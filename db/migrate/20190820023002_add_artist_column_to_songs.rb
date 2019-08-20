class AddArtistColumnToSongs < ActiveRecord::Migration[5.2]
  def change
    add_column :songs, :artist, :string
  end
end
