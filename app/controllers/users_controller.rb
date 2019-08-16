class UsersController < ApplicationController
    before_action :set_user
    
    BACKEND_URL = 'http://localhost:8888'
    FRONTEND_URL = 'http://localhost:3000'
    SPOTIFY_API = 'https://api.spotify.com/v1'

    def index
        users = User.all
        render json: users
    end

    def show
        user = User.find(params[:id])
        render json: user
    end

    private
    
        def set_user
            current_user = User.find(session[:user_id])
        end

end
