Rails.application.routes.draw do
  
  get 'landings/index'
  get '/.well-known/acme-challenge/:id' => 'landings#letsencrypt'
  get "dashboard", to: "users#dashboard", as: 'user_dashboard'

  # this is assigning device controllers for user(s)
  devise_for :users, controllers: {invitations: 'devise/invitations', registrations: "users/registrations", sessions: "users/sessions", passwords: "users/passwords"}, skip: [:sessions, :registrations]


  # error handling routes, this will , pass the code to controller error and action show
  %w( 404 422 500 ).each do |code|
    get code, :to => "landings#errors", :code => code
  end


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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

  # Nested Company Resources 
  resources :companies do
    get "dashboard", to: "companies#dashboard", as: :dashboard
    # get "shortlist", to: "companies#shortlist"
    # get "pend",      to: "companies#pend"
    # get "reject",    to: "companies#reject"
    # get "edit", to: "companies#edit", as: 'edit'
    # post "update", to: "companies#update", as: 'update'
    # resources :jobs do
    #   get "preview", to: "users#preview"
    #   put "invite_sender", to: "jobs#send_invite_mail"
    #   put "shortlist_sender", to: "jobs#send_shortlist_mail"
    #   put "reject_sender", to: "jobs#send_reject_mail"
    #   resources :submissions do
    #     member do
    #       get "like", to: "submissions#upvote"
    #       get "dislike", to: "submissions#downvote"
    #     end
    #     patch    "submissions/status_update"  => "submissions#status_update", as: :status_update        
    #   end
    # end
  end


  # You can have the root of your site routed with "root"
  root 'landings#index'



# If you have the need for more deep customization, 
# for instance to also allow "/sign_in" besides "/users/sign_in", 
# all you need to do is to create your routes normally 
# and wrap them in a devise_scope block in the router:
# This way, you tell Devise to use the scope :user when "/sign_in" is accessed. Notice devise_scope is also aliased as as in your router.


   devise_scope :user do
    get    "login"   => "users/sessions#new",         as: :new_user_session
    post   "login"   => "users/sessions#create",      as: :user_session
    delete "signout" => "users/sessions#destroy",     as: :destroy_user_session
    
    get    "signup"  => "users/registrations#new",    as: :new_user_registration
    post   "signup"  => "users/registrations#create", as: :user_registration
    put    "signup"  => "users/registrations#update", as: :update_user_registration
    get    "account" => "users/registrations#edit",   as: :edit_user_registration
  end

  
end
