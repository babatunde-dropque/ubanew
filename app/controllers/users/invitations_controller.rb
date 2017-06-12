#  added by muyide ibukun, to change the behaviour of invitable controller
class Users::InvitationsController < Devise::InvitationsController
  layout 'signin'
  skip_filter :require_no_authentication, :only => :edit
  before_action :devise_configure_permitted_parameters, if: :devise_controller?
  

  protected

    def devise_configure_permitted_parameters
      sign_out current_user if user_signed_in?
      devise_parameter_sanitizer.permit(:accept_invitation, keys: [:name])
    end
end
