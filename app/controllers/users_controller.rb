class UsersController < ApplicationController
	layout 'user_dashboard'
	before_action :authenticate_user!
	
	# this is used to initial user's object to that it will be available to all 
	# method without recalling it again
	before_filter :set_up_user

    def set_up_user
        @user = current_user
        @notification = Notification.where(user_id: @user.id, read: 0)
    end


    
   def update_notification
	     @notification = Notification.find(params[:notification_id])
	    if !@notification.update_attributes(update_notification_params)
	       render plain: "failure"
	    else
	      render plain: "success"
	    end
   end


	def dashboard
		
    end 


    # parameters used to update the notification
  def update_notification_params
    params.permit(:read)
  end



end
