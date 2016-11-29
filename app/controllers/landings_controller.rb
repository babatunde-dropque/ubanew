class LandingsController < ApplicationController
	layout 'landing'
	
  def index
		if user_signed_in?
			redirect_to user_dashboard_path(current_user)
		end 
		@minimum_password_length = 6
  end

  def contact
    
    
     
  end

  def errors
  	 render status_code.to_s, :status => status_code, :layout => 'signin'
  end

  def letsencrypt
    # use your code here, not mine
    render text: "JJb5NafWAfbIbsyeUhvCzd4NQGgEZK9Mz0izsS9A9UY.CriSZxM1w6GS2r0o8SJiBR7VSo94RaaZqvdmZgVH7eI"
  end
 

protected
 
  def status_code
    params[:code] || 500
  end


end
