Rails.application.routes.draw do
  # resources :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  #
  root 'users#homepage'
  get 'users/homepage'
  get 'users/_yelp_results'
  post 'users/_past_results'
  get 'users/autocomplete'
  get 'users/user_search'
  post 'users/newsfeed'
  post 'users/profile_newsfeed'
  resources :users 
  match '/users/:user_id/update', to: 'users#update', via: :post
  match '/chat', to: 'users#index', via: :get
  resources :users
  resources :sessions
  resources :reviews
  post 'locations/location_reviews'
  post 'locations/location_visits'
  post 'locations/location_photos'
  resources :locations
  resources :visits
  resources :albums
  resources :photos
  resources :friendships
  
  resources :conversations do
    resources :messages
  end
  
  match '/logout', to: 'sessions#destroy', via: :delete
  
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
