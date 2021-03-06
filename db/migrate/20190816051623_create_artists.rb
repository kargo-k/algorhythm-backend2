class CreateArtists < ActiveRecord::Migration[5.2]
  def change
    create_table :artists do |t|
      t.string :name
      t.string :img
      t.string :popularity
      t.string :href
      t.string :spotify_id
      t.timestamps
    end
  end
end
