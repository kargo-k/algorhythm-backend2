class PlaylistsController < ApplicationController
    # before_action :set_user

    def index
        # returns only the current user's playlists
        current_user = User.find_by(access_token: params[:access_token])
        playlists = current_user.playlists
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
        current_user = User.find_by(access_token: params[:access_token])
    end
end
