class Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]
layout 'signin'

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def after_sign_in_path_for(resource)

      if !session[:return_to].nil?
        session[:return_to]
      elsif user_signed_in? && current_user.status == 1
         user_dashboard_path
      elsif user_signed_in? && current_user.status == 0
         user_timeline_path
      else
        user_profile_path
      end
  end

end
