class UsersController < ApplicationController

    BACKEND_URL = 'http://localhost:8888'
    FRONTEND_URL = 'http://localhost:3000'
    SPOTIFY_API = 'https://api.spotify.com/v1'

    def login
        # requests the user to authorize linking to their spotify account
        query_params = {
            client_id: ENV['CLIENT_ID'],
            response_type: "code",
            # redirect_uri: "#{BACKEND_URL}/callback",
            scope: "user-library-read playlist-read-collaborative playlist-modify-private playlist-modify-public playlist-read-private user-top-read",
            show_dialog: true
        }
        url = 'https://accounts.spotify.com/authorize/'
        # redirects user's browser to Spotify's authorization page, which details scopes the app is requestiong
        redirect_to "#{url}?#{query_params.to_query}"
    end

    def callback
        if params[:error]
            # return error if there is one
            puts 'LOGIN ERROR', params
            redirect_to 'http://localhost:8888/login/failure'
        else
            # assemble and send request to spotify for access and refresh token
            body = {
                grant_type: 'authorization_code',
                code: params[:code],
                redirect_uri: 'http://localhost:8888/callback',
                client_id: ENV['CLIENT_ID'],
                client_secret: ENV['CLIENT_SECRET']
            }
            auth_response = RestClient.post('https://accounts.spotify.com/api/token', body)
            # convert response body to json for assignment
            auth_params = JSON.parse(auth_response.body)

            # assemble and send request to Spotify for user profile information
            header = {
                Authorization: "Bearer #{auth_params['access_token']}"
            }
            #! using the endpoint to get the user data
            user_response = RestClient.get("#{SPOTIFY_API}/me", header)
            # convert response.body to json fro assignment
            user_params = JSON.parse(user_response.body)
            # Create new user based on response, or find the existing user in database
            @user = User.find_or_create_by(username: user_params['display_name'],
            spotify_id: user_params['id'],
            href: user_params['href'])
            # update the access and refresh tokens in the db
            @user.update(access_token: auth_params['access_token'], refresh_token: auth_params['refresh_token'])
            
            @user.fetch_playlists
            
            # redirect user to main page
            # FIXME: update to the correct route
            redirect_to 'http://localhost:3000/user'
        end
    end

    def loginFailure
        puts 'login failure here'
        redirect_to "#{BACKEND_URL}/error"
    end

    def index
        users = User.all
        render json: users
    end

    def show
        user = User.find(params[:id])
        render json: user
    end

end
