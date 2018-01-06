Rails.application.routes.draw do
  get '/', to: 'main#index'
  resources :main, only: [:index, :new, :create]
end
