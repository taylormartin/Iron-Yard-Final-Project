class Songkick

  def self.get_events(metro_area_id, start_date, end_date)
    @artists = []
    response = HTTParty.get("http://api.songkick.com/api/3.0/events.json?apikey=#{ENV["SONGKICK_KEY"]}&location=sk:#{metro_area_id}&min_date=#{start_date}&max_date=#{end_date}")
    response.extend Hashie::Extensions::DeepFetch
    events = response.deep_fetch "resultsPage", "results", "event"
    events.each do |event|
      event.extend Hashie::Extensions::DeepFetch
      artist = event.deep_fetch("performance", 0, "artist", "displayName") { |key| nil }
      uri = event.deep_fetch("performance", 0, "artist", "uri") { |key| nil }
      venue = event.deep_fetch("venue", "displayName") { |key| nil }
      top_track_id = Spotify.top_track(artist)
      unless artist.nil? || top_track_id.nil?
        artist_hash = {artist: artist, venue: venue, uri: uri, top_track_id: top_track_id}
        @artists << artist_hash
      end
    end
    @artists
  end

end
