Rails.application.routes.draw do
  get '/', to: 'profiles#new'
  resources :profiles, only: [:view, :new, :create]
end
