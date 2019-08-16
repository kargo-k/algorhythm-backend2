class Song < ApplicationRecord
    # belongs_to :artist
    has_and_belongs_to_many :playlists

    BACKEND_URL = 'http://localhost:8888'
    FRONTEND_URL = 'http://localhost:3000'
    SPOTIFY_API = 'https://api.spotify.com/v1'

    def fetch_song_details(token)
        header = {
            Authorization: "Bearer #{token}"
        }
        #! using the endpoint to get the user's library of tracks
        library_response = RestClient.get("#{SPOTIFY_API}/me/tracks?limit=20", header)
        # max limit is 50
        
        # convert response.body to json 
        library_params = JSON.parse(library_response.body)
        total_tracks = library_params['total']
        songs = library_params['items']
        songs.each do |song|
            song = song['track']
            spotify_id = song['id']
            @new_song = Song.find_or_create_by(spotify_id: spotify_id) 
            name = song['name']
            duration_ms = song['duration_ms']
            href = song['href']
            popularity = song['popularity']

            #TODO do we want to get artists here and create artists????

            # doing another get for audio features
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

            @new_song.update(name: name, duration_ms: duration_ms, href: href, popularity: popularity,danceability: danceability, key: key, acousticness: acousticness, energy: energy, instrumentalness: instrumentalness, liveness: liveness, loudness: loudness, speechiness: speechiness, valence: valence, tempo: tempo)
        end
    end
end
