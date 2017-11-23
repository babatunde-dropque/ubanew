class OauthsController < ApplicationController

# Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def callback
    auth_hash = request.env['omniauth.auth']
    if session[:user_id]
          redirect_to landing_path(current_user)
    else
      # Log user in or sign up

      auth_user = Identity.find_by(provider: auth_hash["provider"], uid: auth_hash["uid"])
      if auth_user
        # Create the session
        sign_in(:user, auth_user.user)
        redirect_to landing_path(current_user)
      else
        user = User.find_or_create_by(email: auth_hash['info']['email'])
        user.name = auth_hash['info']['name']
        image_url =  auth_hash['info']['image']
        user.remote_a_dp_url = image_url
        user.password = "dropque2016app"
        user.save!
        created_auth_user = Identity.create(provider: auth_hash["provider"],uid: auth_hash["uid"], user_id: user.id)
        sign_in(:user, created_auth_user.user)
        redirect_to landing_path(current_user)
      end
    end
  end

  def callback_linkedin
         auth_hash = request.env['omniauth.auth']

    if session[:user_id]
        redirect_to landing_path(current_user)
    else
      # Log user in or sign up
      auth_user = Identity.find_by(provider: auth_hash["provider"], uid: auth_hash["uid"])
      if auth_user
        # Create the session
        sign_in(:user, auth_user.user)
        redirect_to landing_path(current_user)
      else
        user = User.find_or_create_by(email: auth_hash['info']['email'])
        user.name = auth_hash['info']['name']
        image_url =  auth_hash['info']['image']
        user.remote_a_dp_url = image_url
        user.telephone = auth_hash['info']['phone']
        user.a_experience = auth_hash['info']['headline']
        user.a_qualification = auth_hash['info']['industry']
        user.password = "dropque2016app"
        user.save!
        created_auth_user = Identity.create(provider: auth_hash["provider"],uid: auth_hash["uid"], user_id: user.id)
        sign_in(:user, created_auth_user.user)
        redirect_to landing_path(current_user)
      end
    end
  end



  def add_provider(auth_hash)
    # Check if the provider already exists, so we don't add it twice
    unless authorizations.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
      Authorization.create :user => self, :provider => auth_hash["provider"], :uid => auth_hash["uid"]
    end
  end

  def self.find_or_create(auth_hash)
    unless auth = find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
      user = User.create :name => auth_hash["user_info"]["name"], :email => auth_hash["user_info"]["email"]
      auth = create :user => user, :provider => auth_hash["provider"], :uid => auth_hash["uid"]
    end
    auth
  end


  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end


  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end




  def failure
    flash[:alert] = "There was an error while trying to authenticate your account."
    redirect_to new_user_session_path
  end

end
