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

    end
  end
end
