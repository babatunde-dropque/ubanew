class CompaniesController < ApplicationController
	layout 'user_dashboard'
	before_action :authenticate_user!

	def dashboard

	end

	def new
		@user = current_user
		
	end

	def create
		company = Company.new(create_company_params)
		 # return api_error(status: 422, errors: user.errors.full_messages) unless user.valid?
        if company.save
        	#  create add the user as the super admin and ower to company
        	@ower = JointUserCompany.new(status:0, user_id: params[:user_id], company_id: company.id)
        	@ower.save
        	# after this, loop through everyother user and send notification and email to them
        	@collaborator_list = JSON.parse(params[:collaborators_list])
        	@collaborator_list.each do | collborator | 
   
        		@email = collborator["email"]
        		@status = collborator["status"]

        		# invite user with device
        		@user = User.invite!({:email => @email }, current_user)
        		@one_collaborator = JointUserCompany.new(status: @status, user_id: @user.id, company_id: company.id)
                @one_collaborator.save                
            end



        	redirect_to  user_dashboard_path 
        else 
        	 
        end 
	end

	def show

	end


  private

  def create_company_params
    params.permit(:name, :description, :tags, :image, :city, :address, :country, :slug, :user_id)
  end


end
