class Api::V1::ApiController < ApplicationController


	def list_all_interviews_taken(email):
		pass

	def all_interview_by
		user = User.find_by(email: params[:email])
		submission = user.submissions
		render :json => {:submissions => submission }

	def sign_up_candidate():
		pass

	def 
end
