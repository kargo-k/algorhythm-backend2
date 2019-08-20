class AddUriColumnToSongs < ActiveRecord::Migration[5.2]
  def change
    add_column :songs, :uri, :string
  end
end
