Rails.application.routes.draw do
  get '/', to: 'profiles#new'
  resources :profiles, only: %i[index new create]
end
