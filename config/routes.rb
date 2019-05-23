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
    get 'analyze', to: 'analyzer_api#analyze', as: 'analyze'
  end

  controller :benchmark_api do
    get 'analyze_no_threads',
      to: 'benchmark_api#analyze_no_threads',
      as: 'analyze_no_threads'
  end
end
