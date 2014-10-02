class PlaylistController < ApplicationController

  def home

  end

  def select
    metro_area_id = City.find_by_name(params[:city]).metro_area_id
    start_date = params[:start_date]
    end_date = params[:end_date]
    @artists = Songkick.get_events(metro_area_id, start_date, end_date)
  end

  def generate
    @artists = params[:artists]
    Spotify.create_playlist(@artists)
  end

end
