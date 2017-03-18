class Api::V1::ApiController < ApplicationController

   # user controller side
	def list_all_interviews_taken(email):
		pass

	def all_interview_by
		user = User.find_by(email: params[:email])
		submission = user.submissions
		render :json => {:submissions => submission }

	def sign_up_candidate():
		pass

	def 


	private

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
