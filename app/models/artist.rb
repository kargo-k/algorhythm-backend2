class Artist < ApplicationRecord
    has_many :songs
    has_many :playlists, :through => :songs
end
