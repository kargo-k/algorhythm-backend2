class CreatePlaylists < ActiveRecord::Migration[5.2]
  def change
    create_table :playlists do |t|
      t.string :name
      t.string :total_tracks
      t.string :href
      t.string :user_id
      t.string :spotify_id
      t.timestamps
    end
  end
end
