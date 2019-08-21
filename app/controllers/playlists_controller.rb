class PlaylistsController < ApplicationController
    # before_action :set_user

    BACKEND_URL = 'http://localhost:8888'
    FRONTEND_URL = 'http://localhost:3000'
    SPOTIFY_API = 'https://api.spotify.com/v1'

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

    def create
        current_user = User.find_by(access_token: params[:token])
        header = {
            'Authorization': "Bearer #{current_user.access_token}",
            'Content-Type': 'application/json'
        }
        body = {
            name: "#{params[:name]} [Algorhythms]", 
        }
        playlist_response = RestClient.post("https://api.spotify.com/v1/users/#{current_user.spotify_id}/playlists", body.to_json, header)
        playlist_params = JSON.parse(playlist_create_response.body)

        playlist = Playlist.new
        name = playlist_params['name']
        href = playlist_params['href']
        user_id = current_user.id
        spotify_id = current_user.spotify_id

        playlist.update(name: name, href: href, user_id: user_id, spotify_id: spotify_id)
    end
    
    private

    def set_user
        # sets the current user using id before any actions
        current_user = User.find_by(access_token: params[:token])
    end

end
