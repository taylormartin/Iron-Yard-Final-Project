class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  has_one :identity, dependent: :destroy

  def refresh_token_if_expired
    token_expiration = Time.at(self.identity.token_expiration)
    if token_expiration < Time.now
      refresh_token = self.identity.refresh_token
      client_id = ENV['SPOTIFY_APP_ID']
      client_secret = ENV['SPOTIFY_APP_SECRET']
      client_id_and_secret = Base64.strict_encode64("#{client_id}:#{client_secret}")
      response = HTTParty.post(
          "https://accounts.spotify.com/api/token",
          :body => {:grant_type => "refresh_token",
                    :refresh_token => "#{refresh_token}"},
          :headers => {"Authorization" => "Basic #{client_id_and_secret}"}
          )
      self.identity.token = response['access_token']
      self.identity.token_expiration = Time.now.to_i + response['expires_in']
      self.identity.save!
    end
  end

end
