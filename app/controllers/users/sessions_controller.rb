class Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]
layout 'landing'

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
      if params[:intereview_token]
      elsif !session[:return_to].nil?
        session[:return_to]
      elsif user_signed_in? && current_user.status == 1
          dashboard_session
      elsif user_signed_in? && current_user.status == 0
         user_timeline_path
      else
        user_profile_path
      end
  end

  def dashboard_session
    user = current_user
    if user.last_company.nil?
      company_path(user.companies.first)
    elsif
      company = Company.friendly.find(user.last_company)
      company_path(company)
    else
     new_company_path
    end
  end




end
