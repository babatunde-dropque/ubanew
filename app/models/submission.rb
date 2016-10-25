class Submission < ActiveRecord::Base

	belongs_to :job
	belongs_to :user
	belongs_to :staff
	enum status: [:reject, :pend, :shortlist]
	
end
