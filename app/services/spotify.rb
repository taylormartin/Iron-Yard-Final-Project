class Spotify
  include HTTParty
  base_uri 'https://api.spotify.com/v1'

  def self.create_playlist(artists, token, username, playlist_name)
    playlist_id, playlist_url = new_playlist(token, username, playlist_name)
    tracks_array = track_ids(artists)
    add_tracks = post(
      "/users/#{username}/playlists/#{playlist_id}/tracks",
      :headers => {'Authorization' => "Bearer #{token}", "Content-Type" => "application/json"},
      :body => "#{tracks_array}"
    )
    return playlist_url
  end

private

  def self.new_playlist(token, username, playlist_name)
    playlist = post(
        "/users/#{username}/playlists",
        :headers => {'Authorization' => "Bearer #{token}", "Content-Type" => "application/json"},
        :body => {:name => "#{playlist_name}", :public => "false"}.to_json
      )
    return playlist["id"], playlist['external_urls']['spotify']
  end

  def self.track_ids artists
    tracks_array = []
    track_list = []
    artists.each do |artist|
      artist.gsub!(/[' ']/, '+')
      id = search_id(artist)
      unless id.nil?
        track_list << top_five_tracks(id)
      end
    end
    track_list.flatten!
    track_list.each do |track|
      tracks_array << "spotify:track:#{track}"
    end
    tracks_array
  end

  def self.search_id artist
    response = get "/search?q=#{artist}&type=artist"
    response.extend Hashie::Extensions::DeepFetch
    id = response.deep_fetch('artists', 'items', 0, 'id') { |key| nil }
  end

  def self.top_five_tracks id
    #this is a place where I could use the map function
    top_five = []
    response = get "/artists/#{id}/top-tracks?country=US"
    response['tracks'].first(5).each do |track|
      top_five << track['id']
    end
    top_five
  end

end
