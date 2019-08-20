class User < ApplicationRecord
    has_many :playlists
    has_many :songs, :through => :playlists

    BACKEND_URL = 'http://localhost:8888'
    FRONTEND_URL = 'http://localhost:3000'
    SPOTIFY_API = 'https://api.spotify.com/v1'

    def access_token_expired?
        # returns true if access_token is older than 55 minutes, based on update_at
        (Time.now.utc - self.updated_at) > 3300
    end

    def update_token
        # request new access token using refresh token
        # create body of request
        body = {
            grant_type: 'refresh_token',
            refresh_token: self.refresh_token,
            client_id: ENV['CLIENT_ID'],
            client_secret: ENV['CLIENT_SECRET']
        }
        # send the request and update the user's access token
        auth_response = RestClient.post('https://accounts.spotify.com/api/token', body)
        auth_params = JSON.parse(auth_response)
        self.update(access_token: auth_params['access_token'])
    end

    def fetch_spotify_data
        if self.access_token_expired?
            self.update_token
        end

        self.fetch_library
        self.fetch_playlists
    end

    def fetch_library

        if self.access_token_expired?
            self.update_token
        end

        token = self.access_token
        header = {Authorization: "Bearer #{token}"}
        #! using the endpoint to get the user's library of tracks
        library_response = RestClient.get("#{SPOTIFY_API}/me/tracks?limit=20", header)
        # max limit is 50
        
        # convert response.body to json 
        library_params = JSON.parse(library_response.body)
        total_tracks = library_params['total']

        # Create a new library playlist for relating the user's songs that are not associated with a Spotify playist
        library_playlist = Playlist.create(user_id: self.id, name: "#{self.username} - Library")

        songs = library_params['items']
        songs.each do |song|
            song = song['track']
            spotify_id = song['id']

            @target_song = Song.find_by(spotify_id: spotify_id) 
            
            if !@target_song
            # if the song not found in the database, create a new song
                name = song['name']
                duration_ms = song['duration_ms']
                href = song['href']
                popularity = song['popularity']
                img = song['album']['images'][1]['url']
                artist_array = []
                song['artists'].each{|artist| artist_array << artist['name']}
                artist_array = artist_array.join(', ')
                uri = song['uri']

                # doing another fetch for audio features
                #! using the endpoint to get the track's audio features
                track_response = RestClient.get("#{SPOTIFY_API}/audio-features/#{spotify_id}", header)
                # convert response.body to json 
                track_params = JSON.parse(track_response.body)

                danceability = track_params['danceability']
                key = track_params['key']
                acousticness = track_params['acousticness']
                energy = track_params['energy']
                instrumentalness = track_params['instrumentalness']
                liveness = track_params['liveness']
                loudness = track_params['loudness']
                speechiness = track_params['speechiness']
                valence = track_params['valence']
                tempo = track_params['tempo']

                @target_song = Song.create(name: name, duration_ms: duration_ms, href: href, popularity: popularity, danceability: danceability, key: key, acousticness: acousticness, energy: energy, instrumentalness: instrumentalness, liveness: liveness, loudness: loudness, speechiness: speechiness, valence: valence, tempo: tempo, img: img, artist: artist_array, uri: uri)

                self.songs << @target_song
            else
                @target_song
            end
        end
    end

    def fetch_playlists

        if self.access_token_expired?
            self.update_token
        end

        token = self.access_token
        header = {
            Authorization: "Bearer #{token}"
        }
        #! using the endpoint to get the user's playists
        playlists_response = RestClient.get("#{SPOTIFY_API}/me/playlists?limit=5", header)
        # max limit is 50
        
        # convert response.body to json 
        playlists_params = JSON.parse(playlists_response.body)
        
        playlists = playlists_params['items']
        playlists.each do |list|
            user_id = self.id
            spotify_id = list['id']
            
            newplaylist = Playlist.find_or_create_by(spotify_id: spotify_id)

            name = list['name']
            href = list['href']
            total_tracks = list['tracks']['total']

            newplaylist.update(user_id: user_id, name: name, href: href, total_tracks: total_tracks)

        end
    end
end
