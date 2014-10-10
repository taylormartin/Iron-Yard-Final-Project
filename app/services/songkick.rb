class Songkick

  def self.get_events(metro_area_id, start_date, end_date)
    @artists = []
    response = HTTParty.get("http://api.songkick.com/api/3.0/events.json?apikey=#{ENV["SONGKICK_KEY"]}&location=sk:#{metro_area_id}&min_date=#{start_date}&max_date=#{end_date}")
    response.extend Hashie::Extensions::DeepFetch
    events = response.deep_fetch "resultsPage", "results", "event"
    events.each do |event|
      event.extend Hashie::Extensions::DeepFetch
      artist = event.deep_fetch("performance", 0, "artist", "displayName") { |key| nil }
      @artists << artist unless artist.nil?
    end
    @artists
  end

end
