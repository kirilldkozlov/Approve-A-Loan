Rails.application.routes.draw do
  get '/', to: 'profiles#index'

  resources :profiles, only: %i[show index new create], path: 'analyzer' do
    collection do
      post :delete
      post :save
      get :analysis
      get :print
    end
  end

  resources :api_users, only: %i[new create], path: 'api_access'

  post 'authenticate', to: 'authentication#authenticate'

  get 'test', to: 'analyzer_api#test'

  controller :analyzer_api do
    get 'logs', to: 'analyzer_api#logs', as: 'logs'
  end
end
