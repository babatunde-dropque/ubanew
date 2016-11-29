Rails.application.routes.draw do


  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  post '/rate' => 'rater#create', :as => 'rate'
  # rails engine for comment
  mount Commontator::Engine => '/commontator'
  
  get 'applicants/index'
  get 'landings/index'
  get 'contact' => 'landings#contact'
  get '/.well-known/acme-challenge/:id' => 'landings#letsencrypt'
  get "dashboard", to: "users#dashboard", as: 'user_dashboard'
  get "dashboard/account", to: "users#account", as: 'user_account'
  post "dashboard/account", to: "users#account", as: 'user_account_put'
  get "dashboard/check_password", to: "users#check_password", as: 'check_password'


  # post request for applicant data
  post 'applicants/' => 'applicants#index'
  post 'applicants/question' => 'applicants#question'
  post 'applicants/submit_video' => 'applicants#submit_video'
  post 'applicants/upload_file' => 'applicants#upload_file'

  %w( validate_interview validate_email ).each do |action|
    get  action => 'applicants#'+action
  end

  get "check_subdomain", to: "companies#check_subdomain"

  # this is assigning device controllers for user(s)
  devise_for :users, controllers: {invitations: 'users/invitations', registrations: "users/registrations", sessions: "users/sessions", passwords: "users/passwords"}, skip: [:sessions, :registrations]


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
    post "add_collaborators", to: "companies#add_collaborators"
    delete "remove_collaborator", to: "companies#remove_collaborator"
    put "transfer_ownership", to: "companies#transfer_ownership"
    get "edit_preview", to: "companies#edit_preview"
    post "edit_preview", to: "companies#edit_preview"
    get "all_interview", to: "companies#all_interview"

    resources :groups do
      get "showGroupEmail", to: "groups#showGroupEmail"
      get "unshowGroupEmail", to: "groups#unshowGroupEmail"
      # get 'show_group_emails', on: :member
     # get  'show_group_emails' => 'groups#show_emails'

      resources :bulks do
       post 'import', on: :collection
     # collection{post :import
     #            post :fetch}
      end
    end

    resources :interviews do

      # post 'show_group_emails', on: :member
      post 'send_invite_mail', on: :collection
      get "single", to: "interviews#single_interview_submissions"
      get "returnTextFileApi", to: "interviews#returnTextFileApi"
      get "filtered_single_interview", to: "interviews#filtered_single_interview"
      put "change_status", to: "interviews#change_status"
      get "unfinish_submission", to: "interviews#unfinish_submission" 
    end

  end



  # checking if the subdomain is available, if yes to to route
  # if not route back to rool url
  get '/' => 'applicants#index', :constraints => CustomDomainConstraint 

  constraints(CustomDomainConstraint) do
     get '/' => 'applicants#index'
     get 'applicants/' => 'applicants#index'
     get 'applicants/:interview_token/' => 'applicants#index'

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
    put    "update_notification"  => "users#update_notification"
    
    get    "signup"  => "users/registrations#new",    as: :new_user_registration
    post   "signup"  => "users/registrations#create", as: :user_registration
    put    "signup"  => "users/registrations#update", as: :update_user_registration
    get    "account" => "users/registrations#edit",   as: :edit_user_registration
  end

  
end
