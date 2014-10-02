class Spotify

  def self.create_playlist(artists)
    artists.each do |artist|
      artist.gsub!(/[' ']/, '+')
    end
  end

private

  def search

  end

  def top_five_tracks

  end

end
