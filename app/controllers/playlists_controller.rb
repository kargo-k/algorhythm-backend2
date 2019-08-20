class PlaylistsController < ApplicationController
    # before_action :set_user

    def index
        # returns only the current user's playlists
        current_user = User.find_by(access_token: params[:token])
        playlists = current_user.playlists
        render json: playlists
    end

    def show
        playlist = Playlist.find(params[:id])
        playlist.fetch_songs(params[:token])
        render json: {playlist: playlist, songs: playlist.songs}
    end

    def new
        # getting the parameters from the front end
        popularity = params[:popularity]
        key = params[:key]
        acousticness = params[:acousticness]
        danceability = params[:danceability]
        energy = params[:energy]
        instrumentalness = params[:instrumentalness]
        liveness = params[:liveness]
        loudness = params[:loudness]
        speechiness = params[:speechiness]
        valence = params[:valence]
        tempo = params[:tempo]


    end
    
    private

    def set_user
        # sets the current user using id before any actions
        current_user = User.find_by(access_token: params[:access_token])
    end

end
