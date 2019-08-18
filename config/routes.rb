Rails.application.routes.draw do
  resources :artists
  resources :songs
  resources :playlists
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/login', to: 'users#login', as: 'login'
  get '/error', to: 'users#loginFailure', as: 'loginfailure'
  get '/callback', to: 'users#callback', as: 'callback'
  
end
