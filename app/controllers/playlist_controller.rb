class PlaylistController < ApplicationController

  def home
    @cities = City.all
  end

  def select
    if params[:city] == ""
      redirect_to playlist_path, :flash => { :alert => "Please select a city" }
    elsif params[:start_date] == ""
      redirect_to playlist_path, :flash => { :alert => "Please select a start date" }
    elsif params[:end_date] == ""
      redirect_to playlist_path, :flash => { :alert => "Please select an end date" }
    elsif params[:start_date] > params[:end_date]
      redirect_to playlist_path, :flash => { :alert => "Start date can't be after end date" }
    else
      metro_area_id = params[:city]
      start_date = params[:start_date]
      end_date = params[:end_date]
      @artists = Songkick.get_events(metro_area_id, start_date, end_date)
    end
  end


  def generate
    if params[:playlist_name] == ""
      playlist_name = "nameless playlist"
    else
      playlist_name = params[:playlist_name]
    end
    current_user.refresh_token_if_expired
    artists = params[:artists]
    username = current_user.identity.auth_data['uid']
    token = current_user.identity.token
    @playlist_url = Spotify.create_playlist(artists, token, username, playlist_name)
  end

end
