class ListingsController < ApplicationController
	layout 'listing'

	# this code only gets
	def listing_interview
		if params[:search] && request.subdomain.present? && request.subdomain != "wwww"

		   @company = Company.find_by(subdomain:request.subdomain )
		   interviews_all = @company.interviews
		   @interviews = interviews_all.where("title LIKE ?", "%#{params[:search]}%").paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
		   
		elsif  request.subdomain.present? && request.subdomain != "wwww"
    		 @company = Company.find_by(subdomain: request.subdomain)
    		 @interviews = @company.interviews.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
		
		elsif params[:search]
			 @interviews = Interview.search(params[:search]).paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
		
		else
		  @interviews = Interview.paginate(:page => params[:page], :per_page => 5).order('created_at DESC')
		end
	end



end
