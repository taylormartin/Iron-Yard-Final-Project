class Songkick

  def self.get_events(metro_area_id, start_date, end_date)
    @artists = []
    response = HTTParty.get("http://api.songkick.com/api/3.0/events.json?apikey=#{ENV["SONGKICK_KEY"]}&location=sk:#{metro_area_id}&min_date=#{start_date}&max_date=#{end_date}")
    response["resultsPage"]["results"]["event"].each do |event|
      @artists << event["performance"][0]["displayName"]
    end
    @artists
  end

end
