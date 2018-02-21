Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  post '/rate' => 'rater#create', :as => 'rate'
  # rails engine for comment
  mount Commontator::Engine => '/commontator'

  get 'listing' => 'listings#listing_interview', as: 'listing'
  get 'listing-inner' => 'listings#listing_inner', as: 'listing_inner'
  get 'listing-approval' => 'listings#listing_approval', as: 'approval_page'
  get 'applicants/index'
  get 'landings/index', as: 'landing'
  get '/newhome', to: 'landings#newhome', as: 'newhome'
  get '/pricing', to: 'landings#pricing', as: 'pricing'
  post 'landings/requestdemo', to: "landings#request_demo"
  put 'update_approval_status' => 'listings#update_approval_status', as: 'update_approval'
  get "build_profile", to: "users#build_profile", as: 'build_profile', :format => false
  post "build_profile_update", to: "users#update_profile", as: 'update_profile', :format => false
  put "become_interviewer", to: "users#become_interviewer", as: 'become_interviewer', :format => false
  put "become_applicant", to: "users#become_applicant", as: 'become_applicant', :format => false
  get "profile", to: "users#profile", as: 'user_profile', :format => false
  get "application_timeline", to: "users#application_timeline", as: 'user_timeline', :format => false
  get "dashboard/account", to: "users#account", as: 'user_account', :format => false
  post "dashboard/account", to: "users#account", as: 'user_account_put'
  get "dashboard/check_password", to: "users#check_password", as: 'check_password'
  get "dashboard/interviews", to: "users#interviews", as: 'user_interviews', :format => false
  get 'demo_login' , to: "users#user_demo_login", as: 'user_demo_login'
  get 'demo_in' , to: "users#trigger_login", as: 'trigger_login'
  get 'contact', to: "landings#contact", as: 'contact'
  get 'payment_test', to: "payment#payment_test", as: 'payment_test'
  get 'payment_test_url', to: "payment#payment_test_callback",  as: 'payment_test_callbadk'
  get 'payment_test_submit', to: "payment#payment_test_submit", as: 'payment_test_submit'

  put 'update_education', to: "users#update_education", as: 'update_education'
  put 'update_experience', to: "users#update_experience", as: 'update_experience'
  put 'update_skills', to: "users#update_skills", as: 'update_skills'
  put 'update_user_details', to: "users#update_user_details", as: 'update_user_details'
  get 'retrieve_education', to: "users#retrieve_education", as: 'retrieve_education'
  delete 'delete_education', to: "users#delete_education", as: 'delete_education'

  post "update_account_profile", to: "users#update_account_profile", as: "update_account_profile"
  post "update_account_skill", to: "users#update_account_skill", as: "update_account_skill"  

  get "check_if_user_exist", to: "users#check_if_user_exist", as: "check_if_user_exist"
  post "login_sign_up", to: "users#login_sign_up", as: "login_sign_up"

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



  # Nested Company Resources
  resources :companies do
    #post 'send_invite_mail', on: :collection
    #get "interview_reminder", to: "companies#interview_reminder"
    post "add_collaborators", to: "companies#add_collaborators"
    delete "remove_collaborator", to: "companies#remove_collaborator"
    put "transfer_ownership", to: "companies#transfer_ownership"
    get "edit_preview", to: "companies#edit_preview"
    post "edit_preview", to: "companies#edit_preview"
    get "all_interview", to: "companies#all_interview"
    get "preview", to: "companies#preview"
    get "card_preview", to: "companies#card_preview", as: 'card_preview'
    get "talent", to: "companies#search_talent", as: "talent"
    get "talent/:id", to: "companies#show_talent", as: "show_talent"
    get "organization_members", to: "companies#organization_members", as: "organization_members"

    resources :groups do
       get 'show_group_emails', on: :member
       resources :bulks do
          post 'import', on: :collection
      end
    end

    resources :interviews do
      post 'send_invite_mail', on: :collection
      get "reminder", to: "interviews#reminder"
      get "sms_reminder", to: "interviews#sms_reminder"
      get "double_reminder", to: "interviews#double_reminder"
      get "mass", to: "interviews#mass_notify"
      get "analytics", to: "interviews#analytics"
      get "single", to: "interviews#single_interview_submissions"
      get "returnTextFileApi", to: "interviews#returnTextFileApi"
      get "filtered_single_interview", to: "interviews#filtered_single_interview"
      put "change_status", to: "interviews#change_status"
      # get "shortlist", to: "interviews#shortlist"
      # get "reject", to: "interviews#reject"
      get "unfinish_submission", to: "interviews#unfinish_submission" 
      get "export_details", to: "submissions#export",  as: 'export_submissions'
      get "shortlist", to: "submissions#shortlist"
      get "reject", to: "submissions#reject"
    end

  end


  get 'users/auth/linkedin/callback', to: 'oauths#callback_linkedin', as: 'oauth_callback_linked'
  get 'users/auth/facebook/callback', to: 'oauths#callback'
  get 'users/auth/failure', to: 'oauths#failure', as: 'oauth_failure'
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

  #get 'users/auth/linkedin/callback' => 'users#createt'

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



# namespace and controller for api
namespace :api do
    namespace :v1 do
      get "token", to: "api#token"
      put "send_invitation", to: "api#send_invitation"

    end
  end

end
