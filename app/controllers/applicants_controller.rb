class ApplicantsController < ApplicationController
  layout 'applicants'
  before_filter :set_up_company, :except => [:validate_interview]
  
  def index

  	# check details parameter and validate interview token once again
  	if (params[:page] == "details" && Interview.exists?(interview_token: params[:interview_token]) )
  	
  		# check if user exist and create if not
  		if User.exists?(email: params[:email])

  		else

  	end

    

     # create new user

  		render "details"
  	end

  	

  	# render "edit"
  end


  def validate_interview
    if  Interview.exists?(interview_token: params[:interview_token])
      render plain: "success"
    else
      render plain: "error"
    end 
  end 

  


  private

  def set_up_company 
  	# get subdomain
  	subdomain = request.subdomain
  	@company = Company.find_by(subdomain: subdomain)
  	if @company.nil?
  		redirect_to root_path
  	end
  end
end
