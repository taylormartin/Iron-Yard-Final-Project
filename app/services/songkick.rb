class Songkick

  #TODO: need to account for events that aren't performances
  def self.get_events(metro_area_id, start_date, end_date)
    @artists = []
    response = HTTParty.get("http://api.songkick.com/api/3.0/events.json?apikey=#{ENV["SONGKICK_KEY"]}&location=sk:#{metro_area_id}&min_date=#{start_date}&max_date=#{end_date}")
    #TODO: put this in a begin rescue block in case there isn't a performance
    #TODO: hashie mash deep fetch is a good solution here
    response["resultsPage"]["results"]["event"].each do |event|
      @artists << event["performance"][0]["artist"]["displayName"]
    end
    @artists
  end

end
