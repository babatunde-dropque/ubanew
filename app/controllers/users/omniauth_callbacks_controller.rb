class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end
  #def linkedin
    #raise request.env["omniauth.auth"]
    # @user = User.find_for_linkedin_oauth(request.env["omniauth.auth"])
    #   if @user.persisted?
    #     redirect_to root_path, :event => :authentication
    #     # sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
    #     #  set_flash_message(:notice, :success, :kind => "LinkedIn") if is_navigational_format?
    #     else
    #       session["devise.linkedin_data"] = request.env["omniauth.auth"]
    #       redirect_to root_path
    #     end
  #end



   #raise request.env["omniauth.auth"]
  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
