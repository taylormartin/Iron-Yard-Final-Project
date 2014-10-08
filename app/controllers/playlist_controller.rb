class PlaylistController < ApplicationController

  def home

  end

  def select
    #TODO: put in fix for empty date and city fields
    metro_area_id = City.find_by_name(params[:city]).metro_area_id
    start_date = params[:start_date]
    end_date = params[:end_date]
    @artists = Songkick.get_events(metro_area_id, start_date, end_date)
  end

  def generate
    artists = params[:artists]
    id = current_user.identity.auth_data['uid']
    current_user.refresh_token_if_expired
    token = current_user.identity.auth_data['credentials']['token']
    Spotify.create_playlist(artists, token, id)
  end

end
