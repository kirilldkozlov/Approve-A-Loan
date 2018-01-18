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

  post 'authenticate', to: 'authentication#authenticate'

  get 'test', to: 'analyzer_api#test'
end
