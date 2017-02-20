class ListingsController < ApplicationController
	layout 'listing'
	before_action :authenticate_user!, :except => [:listing_interview]
	before_action :validate_user, :except => [:listing_interview]

	# this code only gets
	def listing_interview
		if params[:search] && request.subdomain.present? && request.subdomain != 'www'

		   @company = Company.find_by(subdomain:request.subdomain )
		   interviews_all = @company.interviews.where(approve:1)
		   @interviews = interviews_all.where("title LIKE ?", "%#{params[:search]}%").paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
		   
		elsif  request.subdomain.present? && request.subdomain != 'www'
    		 @company = Company.find_by(subdomain: request.subdomain)
    		 @interviews = @company.interviews.where(approve:1).paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
		
		elsif params[:search]
			 @interviews = Interview.search(params[:search]).where(approve:1).paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
		
		else
		  @interviews = Interview.where(approve:1).paginate(:page => params[:page], :per_page => 5).order('created_at DESC')
		end

	end


	def listing_approval
		
		  @interviews_approval = Interview.where.not(company_id: nil).paginate(:page => params[:page], :per_page => 5).order('created_at DESC')
	
	end


	def update_approval_status
		interview = Interview.friendly.find(params[:id])
		interview.update(approve:params[:value])
		redirect_to  approval_page_path(page:params[:page])
	end


	private 

	# test if user has access to this page
	def validate_user
		if current_user.email == "admin@dropque.com" || current_user.email == "ibukun@dropque.com" || current_user.email == "opeyemi@dropque.com" || current_user.email == "yinka@dropque.com" || current_user.email == "mustapha@dropque.com"
			
		else 
			redirect_to  landing_path
		end
	end



end
