class CreateSongs < ActiveRecord::Migration[5.2]
  def change
    create_table :songs do |t|
      t.string :name
      t.integer :duration_ms
      t.integer :popularity
      t.integer :key
      t.float :acousticness
      t.float :danceability
      t.float :energy
      t.float :instrumentalness
      t.float :liveness
      t.float :loudness
      t.float :speechiness
      t.float :valence
      t.float :tempo
      t.string :href
      t.integer :artist_id
      t.string :spotify_id
      t.timestamps
    end
  end
end
