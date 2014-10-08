class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  has_one :identity, dependent: :destroy

  def refresh_token_if_expired
    #TODO: need to account for possible new refresh token too
    # token_expiration = Time.at(self.identity.token_expiration)
    token_expiration = Time.now - 1.days
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
      self.identity.token_expiration = self.identity.token_expiration + response['expires_in']
      binding.pry
      self.identity.save!
    end
  end

  # def refresh_token_if_expired
  #   refresh_token = self.identity.auth_data['credentials']['refresh_token']
  #   token_expiration = Time.at(self.identity.auth_data['credentials']['expires_at'])
  #   client_secret = Base64.strict_encode64(ENV['SPOTIFY_APP_SECRET'])
  #   if token_expiration < Time.now
  #     response = HTTParty.post('https://accounts.spotify.com/api/token',
  #     {
  #       :headers => {"Authorization" => "Basic #{client_secret}"},
  #       :data => {'grant_type' => 'refresh_token', 'refresh_token' => refresh_token}
  #       })
  #     binding.pry
  #   else
  #     binding.pry
  #   end
  # end

end
