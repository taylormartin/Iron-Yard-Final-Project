class Songkick

  def self.get_events(metro_area_id, start_date, end_date)
    artists = []
    response = HTTParty.get("http://api.songkick.com/api/3.0/events.json?apikey=#{ENV["SONGKICK_KEY"]}&location=sk:#{metro_area_id}&min_date=#{start_date}&max_date=#{end_date}")
    response.extend Hashie::Extensions::DeepFetch

    total_entries = response.deep_fetch "resultsPage", "totalEntries"
    pages = (total_entries.to_f / 50).ceil
    additional_calls = pages - 1
    events = response.deep_fetch "resultsPage", "results", "event"

    events.each do |event|
      event.extend Hashie::Extensions::DeepFetch
      artist = event.deep_fetch("performance", 0, "artist", "displayName") { |key| nil }
      uri = event.deep_fetch("performance", 0, "artist", "uri") { |key| nil }
      venue = event.deep_fetch("venue", "displayName") { |key| nil }
      date_string_one = event.deep_fetch("start", "date") { |key| nil }
      date_string_two = Date.parse(date_string_one)
      date = date_string_two.strftime('%a %d %b %Y')
      unless artist.nil?
        artist_hash = {artist: artist, venue: venue, uri: uri, date: date}
        artists << artist_hash
      end
    end

    page = 2
    while additional_calls > 0 do
      response = HTTParty.get("http://api.songkick.com/api/3.0/events.json?apikey=#{ENV["SONGKICK_KEY"]}&location=sk:#{metro_area_id}&min_date=#{start_date}&max_date=#{end_date}&page=#{page}")
      response.extend Hashie::Extensions::DeepFetch
      events = response.deep_fetch "resultsPage", "results", "event"

      events.each do |event|
        event.extend Hashie::Extensions::DeepFetch
        artist = event.deep_fetch("performance", 0, "artist", "displayName") { |key| nil }
        uri = event.deep_fetch("performance", 0, "artist", "uri") { |key| nil }
        venue = event.deep_fetch("venue", "displayName") { |key| nil }
        date_string_one = event.deep_fetch("start", "date") { |key| nil }
        date_string_two = Date.parse(date_string_one)
        date = date_string_two.strftime('%a %d %b %Y')
        unless artist.nil?
          artist_hash = {artist: artist, venue: venue, uri: uri, date: date}
          artists << artist_hash
        end
      end
      page += 1
      additional_calls = additional_calls - 1
    end

    artists
  end

end
