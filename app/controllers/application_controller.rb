class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def send_notification(user_id, type, sender_id, company_name)

  	  if (type == 1) 
  	  	# user submissions
  	  	message = ""
  	  elsif (type == 2)
  	  	# company invitation
  	  	sender = User.find(sender_id)
  	  	message = sender.name + ' (' + sender.email + ') ' + 'added you to ' + company_name

  	  elsif(type == 3)
  	  	# message from another user to company 
  	  	message = ""

      elsif (type == 4)
        # remove you from another company
        sender = User.find(sender_id)
        if (user_id == sender_id)
          message = 'You' + ' (' + sender.email + ') ' + 'left ' + company_name
        else
          message = sender.name + ' (' + sender.email + ') ' + 'removed you from ' + company_name
        end

      elsif (type == 5)
      # Transer Ownership to you
      sender = User.find(sender_id)
      message = sender.name + ' (' + sender.email + ') ' + 'transfer Ownership of ' + company_name + ' to you '
  	  end

  	  notification =  Notification.new(read: 0, type_notification: type, message: message , user_id: user_id )
      notification.save!

      # get receivers object
      # receiver = User.find(user_id)
      # UserMailer.receive_notification(receiver, message).deliver_later

  end


   



  	#  Documentation on sending notification , created by Muyide Ibukun
	#  user_id id the user_id to receive the notification
	#  type is the type of message to receive
	#  if reference_id is not nil, then its for the reference sending 
	#  notification to the user
	#   type 1: submission notification
	# 	type 2: invitation  to join a company notification
	# 	type 3: message notification by applicant
	#   type 3: remove you from a company
	# 
end
