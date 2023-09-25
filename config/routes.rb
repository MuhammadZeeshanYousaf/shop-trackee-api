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
      resources :categories, only: :index
      resources :shops do
        resources :products, concerns: :buildable
        resources :services, concerns: :buildable
      end

      resources :favorites, only: [:index, :create] do
        delete :destroy, on: :collection
      end

      controller :customers do
        get 'search_all', 'search', 'search_by_category'
      end

      scope 'seller', controller: :sellers do
        get 'stats'
      end

      scope 'customer' do
        get 'history', controller: :search_histories
        resources :order_requests, except: :index do
          delete 'remove', on: :member
        end
      end

      resources :order_requests, only: :index do
        scope 'seller' do
          patch ':status', action: 'update_status', on: :member
          delete 'remove', on: :member
        end
      end
      

    end
  end
end
