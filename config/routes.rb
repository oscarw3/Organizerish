Rails.application.routes.draw do

  

  get 'users/new'

  get 'reservations/index'

  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  resources :resources
  get '/resources/:id/permissions', to: 'resources#permissions', as: 'permissions_resource'
  post '/resources/:id/permissions', to: 'resources#updatepermissions', as: 'update_permissions_resource'
  resources :groups
  resources :reservations do
    member do
      get 'approve'
      end
    end

  get '/search', to: 'reservations#index', as: 'search'

  get 'netidsignin', to: 'signin#checknetid', as: 'signin'


  resources :users, except: :create
  post 'create_user' => 'users#create', as: :create_user
  root 'reservations#index'

  patch '/resources/tags/remove/:resource/:tag', to: 'resources#removetag', as: 'resource_remove_tags'
  patch '/resources/tags/add/:resource/:tag', to: 'resources#addtag', as: 'resource_add_tags'
  # You can have the root of your site routed with "root"
  
  namespace :api, defaults: {format: 'json'} do 
    resources :resources
    resources :groups
    resources :reservations
    resources :users, except: :create
    post 'create_user' => 'users#create', as: :create_user

  end

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
