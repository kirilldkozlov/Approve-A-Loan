Rails.application.routes.draw do
  get '/', to: 'profiles#new'
  resources :profiles, only: [:index, :new, :create]
end
