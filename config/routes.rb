Rails.application.routes.draw do
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }

  get '/playlist', to: 'playlist#home', as: 'playlist'
  post '/playlist/select', to: 'playlist#select', as: 'playlist_select'
  post 'playlist/generate', to: 'playlist#generate', as: 'playlist_generate'

  root to: "playlist#home"

end
