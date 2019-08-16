Rails.application.routes.draw do
  resources :artists
  resources :songs
  resources :playlists
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/login', to: 'sessions#login', as: 'login'
  get '/login/failure', to: 'sessions#loginFailure', as: 'loginfailure'
  get '/callback', to: 'sessions#callback', as: 'callback'
  delete '/logout', to: 'sessions#destroy', as: 'logout'
end
