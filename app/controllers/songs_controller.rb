class SongsController < ApplicationController
    # before_action :set_user, only: [:index]

    def index
        # returns only the current users songs
        current_user = User.find_by(access_token: params[:access_token])
        songs = current_user.songs
        render json: songs
    end

    def show
        song = Song.find(params[:id])
        render json: song
    end

    private

    def set_user
        # sets the current user using id before any actions
        current_user = User.find_by(access_token: params[:access_token])
    end
    
end
