class Api::V1::ApiController < ApplicationController

	#skip csrf in the controller
	skip_before_action :verify_authenticity_token
  
	def send_invitation

		 if User.exists?(email: "bot@dropque.com")
	        bot_user = User.find_by(email:"bot@dropque.com")
	       	user = User.invite!({:email => params[:email] }, bot_user)
	    else
	         bot_user = User.new(name: "Dropque bot", email: "bot@dropque.com", password: 'dropqueappbot', password_confirmation: 'dropqueapp')
	         bot_user.save()
	         user = User.invite!({:email => params[:email] }, bot_user)  
	    end
		render json: {"success":"Invitation email sent"}, status: 200
	end

	def token
	    @interview = Interview.find_by(interview_token: params[:interview_token])
	    @company = @interview.company
	    render :json => {:interview => @interview ,:company => @company }
    end

   # user controller side
	# def list_all_interviews_taken(email):
	# 	pass
	# end

	# def all_interview_by
	# 	user = User.find_by(email: params[:email])
	# 	submission = user.submissions
	# 	render :json => {:submissions => submission }

	# def sign_up_candidate():
	# 	pass

	# def 


	# private

	#   def authenticate_user

	#   end

	# def create_params
	#     params.require(:company).permit(
	#       :email, :password, :password_confirmation, :name, :telephone
	#     ).delete_if{ |k,v| v.nil?}
	# end

	#   def update_params
	#     create_params
	#   end

	#   # parameters used to update the notification
	#   def update_notification_params
	#     params.permit(:read)
	#   end


end
