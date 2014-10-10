class PlaylistController < ApplicationController

  def home


  end

  def select
    if params[:city] == ""
      redirect_to playlist_path, :flash => { :alert => "Please select a city" }
    elsif params[:start_date] == ""
      redirect_to playlist_path, :flash => { :alert => "Please select a start date" }
    elsif params[:end_date] == ""
      redirect_to playlist_path, :flash => { :alert => "Please select an end date" }
    else
      metro_area_id = City.find_by_name(params[:city]).metro_area_id
      start_date = params[:start_date]
      end_date = params[:end_date]
      @artists = Songkick.get_events(metro_area_id, start_date, end_date)
    end
  end


  def generate
    current_user.refresh_token_if_expired
    artists = params[:artists]
    username = current_user.identity.auth_data['uid']
    token = current_user.identity.token
    @playlist_url = Spotify.create_playlist(artists, token, username)
  end

end
