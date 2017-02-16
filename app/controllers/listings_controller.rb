class ListingsController < ApplicationController
	layout 'listing'

	# this code only gets
	def listing_interview
		if params[:search]
		   @interviews = Interview.search(params[:search]).paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
		else
		  @interviews = Interview.paginate(:page => params[:page], :per_page => 5).order('created_at DESC')
		end
	end



end
