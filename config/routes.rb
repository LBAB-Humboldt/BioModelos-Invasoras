Biomodis::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { registrations: "devise2/registrations", sessions: "devise2/sessions" }
  #devise_for :users
  get "models/visor"
  get "models/download_model"
  get "species/species_content"
  get "species/species_models"
  get "users/edit_profile"
  get "comments/child_comments"
  get "home/feedback"
  get "home/active_species"
  post "home/send_message"
  post "ratings/rate_model"
  post "ratings/exists_rating"
  post "group_users/set_state"
  post "groups/form_new_group"
  post "groups/email_new_group"
  post "species_groups/set_state"
  post "species/comment_point"
  post "species/create_comment_point"
  post "groups/bulk_email"
  post "groups/email_invitation"
  post "species/species_by_class"
  post "species/add_ecological_variable"
  post "species/add_altitude_range"
  post "reviews/reviews_by_species"
  post "regions/save_region_user"
  post "species/get_altitude_range"
  post "species/adv_search"
  resources :regions do
    get :regions_by_user, :on => :collection
  end
  resources :ratings, only: [:destroy]
  resources :comments, :only => [:create, :destroy, :edit, :update]
  resources :home, :only => [:show]
  resources :reviews, :only => [:show, :create, :destroy]
  resources :users, :only => [:show, :edit, :update]
  resources :user_relationships, :only => [:create]
  resources :models, :only => [:index, :new, :create]
  resources :species, :only => [:new, :create, :edit] do
    get :autocomplete, :on => :collection
    get :regions_autocomplete, :on => :collection
    get :eco_variables_search, :on => :collection
  end 
  resources :faq, :only => [:index]
  resources :groups do
  end
  resources :species_groups, :only => [:index, :create, :update]
  resources :group_users do
  end

  # connect '/models/search', :controller => 'models', :action => 'search'
  #get "models/index"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#show'

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
