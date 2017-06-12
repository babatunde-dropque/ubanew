class OauthsController < ApplicationController

# Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  protect_from_forgery with: :null_session

  def callback
    begin
      oauth = OauthService.new(request.env['omniauth.auth'])
             oauth.create_oauth_account!
     # if oauth_account = oauth.create_oauth_account!
          ...
          #redirect_to Config.provider_login_path
          redirect_to user_timeline_path
     # end
    rescue => e
      flash[:alert] = "There was an error while trying to authenticate your account."
      redirect_to register_path
    end
  end


  def failure
    flash[:alert] = "There was an error while trying to authenticate your account."
    redirect_to register_path
  end

end
