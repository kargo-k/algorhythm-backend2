class User < ApplicationRecord
    has_many :playlists
    has_many :songs, :through => :playlists
end
