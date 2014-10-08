class Spotify
  include HTTParty
  base_uri 'http://api.spotify.com/v1'

  def self.create_playlist(artists, token, id)
    tracks = track_ids(artists)

    playlist = post("/users/#{id}/playlists",
      {
        :headers => {'Authorization' => 'Bearer {#{token}}', "Content-Type" => "application/json"}
        # :data => {"{\"name\":\"New Playlist\", \"public\":false}"}
      })
  end

private

  def self.track_ids(artists)
    track_list = []
    artists.each do |artist|
      artist.gsub!(/[' ']/, '+')
      id = search_id(artist)
      track_list << top_five_tracks(id)
    end
    track_list.flatten!
  end

  def self.search_id artist
    response = get "/search?q=#{artist}&type=artist"
    id = response['artists']['items'][0]['id']
  end

  def self.top_five_tracks id
    #this is a place where I could user the map function
    top_five = []
    response = get "/artists/#{id}/top-tracks?country=US"
    response['tracks'].first(5).each do |track|
      top_five << track['id']
    end
    top_five
  end

end
