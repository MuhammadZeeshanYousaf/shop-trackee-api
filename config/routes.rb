Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      devise_for :users,
                 controllers: { tokens: 'devise/api/tokens' },
                 defaults: { format: :json }

      # ... other API routes ...
      concern :buildable do
        collection do
          get 'new'
          put '(:id)/images', action: 'create_or_upload'
          patch ':id/images/:image_id/replace', action: 'replace_image'
          delete ':id/images/:image_id', action: 'remove_image'
          get ':id/images/:image_id/recognize', action: 'recognize'
        end
      end

      resource :user, only: :update
      resources :shops do
        resources :products, concerns: :buildable
        resources :services, concerns: :buildable
      end

      scope 'favorites' do
        post '/', to: "favorites#create"
        delete '/', to: 'favorites#destroy'
      end

      get 'search_all', to: 'customers#search_all'

    end
  end
end
