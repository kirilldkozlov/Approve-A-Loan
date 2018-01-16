Rails.application.routes.draw do
  get '/', to: 'profiles#index'

  resources :profiles, only: %i[show index new create], path: "analyzer" do
    collection do
      post :delete
      get :analysis
      get :print
    end
  end
end
