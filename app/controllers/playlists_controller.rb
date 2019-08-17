class PlaylistsController < ApplicationController
    # before_action :set_user

    def index
        # returns only the current user's playlists
        # playlists = current_user.playlists
        playlists = Playlist.all
        render json: playlists
    end

    def show
        playlist = Playlist.find(params[:id])

        newplaylist.fetch_songs(token)

        render json: {playlist: playlist, songs: playlist.songs}
    end
    
    private

    def set_user
        # sets the current user using id before any actions
        current_user = User.find(params[:user_id])
        byebug
    end
end
