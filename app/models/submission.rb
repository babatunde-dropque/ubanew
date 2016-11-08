class Submission < ActiveRecord::Base

	belongs_to :interview
	belongs_to :user
	enum status: [:reject, :pend, :shortlist]

	# allow user to be able to commend on this model
	acts_as_commontable
	ratyrate_rateable "response"
	
end
