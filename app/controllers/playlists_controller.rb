class PlaylistsController < ApplicationController
    before_action :set_user, only: [:index]

    def index
        # returns only the current user's playlists
        playlists = current_user.playlists
        render json: playlists
    end

    def show
        playlist = Playlist.find(params[:id])
        render json: {playlist: playlist, songs: playlist.songs}
    end
    
    private

    def set_user
        # sets the current user using id before any actions
        current_user = User.find(params[:user_id])
    end
end
