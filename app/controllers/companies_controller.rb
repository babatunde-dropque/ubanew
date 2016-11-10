class CompaniesController < ApplicationController
	layout 'user_dashboard'
	before_action :authenticate_user!
    before_filter :set_up_user
    before_filter :set_up_company, :except => [:new, :create]

   

	def show

        @user_status = JointUserCompany.find_by(user_id: @user.id, company_id: @company.id)
        @sigin_in_count = current_user.sign_in_count.to_s
        @all_interview = @company.interviews
        # @interviews = @company.interviews.includes(:users).where(submissions: {status: nil}).paginate(:page => params[:page], :per_page => 5) 
	end

	def new
		
		
	end


    def edit_preview
        if params[:properties].present?
            @company.update_attributes(company_properties)
        end 
         @editable = "true"
        render  :layout => 'applicants', :template => 'applicants/index'
    end


    def all_interview
        @all_interview = @company.interviews

    end

    def add_collaborators
        # after this, loop through everyother user and send notification and email to them
            collaborator_list = JSON.parse(params[:collaborators_list])
            collaborator_list.each do | collborator | 
   
                email = collborator["email"]
                status = collborator["status"]

                # invite user with device
                user = User.invite!({:email => email }, current_user)

                # check if  user exit in the company
                result = JointUserCompany.find_by(user_id: user.id, company_id: @company.id)

                if result.nil?
                    # send notification 
                    self.send_notification(user.id, 2 , params[:user_id], @company.name)

                    # add user to joint_user_company model
                    one_collaborator = JointUserCompany.new(status: status, user_id: user.id, company_id: @company.id)
                    one_collaborator.save 

                end
            end

        redirect_to edit_company_path(params[:company_id] || params[:id])
    end


    #remove 
    # do to, kindly change this to find by user and company so that no one can just passed a
    # delete call to ajax to delete any user's collaboration
    def remove_collaborator
        user_company = JointUserCompany.find(params[:user_company_id])
        if !user_company.destroy
           render plain: "failure"
        else
          # send notification 
          self.send_notification(user_company.user.id, 4 , @user.id, @company.name)
          render plain: "success"
        end
    end

    # transfer ownership
    def transfer_ownership
         current_owner = JointUserCompany.find(params[:current_owner])
         new_owner = JointUserCompany.find(params[:new_owner])
        if current_owner.update_attributes(status: 1) && new_owner.update_attributes(status: 0)
             # send notification 
            self.send_notification(new_owner.user.id, 5 , current_owner.user.id, @company.name)
            redirect_to edit_company_path(@company)    
        else

        end        
    end



    def edit
        @user_company = JointUserCompany.find_by(user_id: @user.id, company_id: @company.id) 
        @collborators = @company.joint_user_companies
        @user_status = @user_company.status
    end


    def update  
        @company.update_attributes(create_company_params)
        redirect_to edit_company_path
        
    end

	def create
		company = Company.new(create_company_params)
		 # return api_error(status: 422, errors: user.errors.full_messages) unless user.valid?
        if company.save
        	#  create add the user as the super admin and ower to company
        	owner = JointUserCompany.new(status:0, user_id: params[:user_id], company_id: company.id)
        	owner.save
        	# after this, loop through everyother user and send notification and email to them
        	collaborator_list = JSON.parse(params[:collaborators_list])
        	collaborator_list.each do | collborator | 
   
        		email = collborator["email"]
        		status = collborator["status"]

        		# invite user with device
        		user = User.invite!({:email => email }, current_user)

                 # check if  user exit in the company
                result = JointUserCompany.find_by(user_id: user.id, company_id: company.id)
                if result.nil?

                    # send notification 
                    self.send_notification(user.id, 2 ,params[:user_id], company.name)

                    # add user to joint_user_company model
            		one_collaborator = JointUserCompany.new(status: status, user_id: user.id, company_id: company.id)
                    one_collaborator.save   
                end             
            end

        	redirect_to  user_dashboard_path 
        else 
        	 
        end 
	end

	


  private

  def create_company_params
    params.permit(:name, :description, :tags, :image, :city, :address, :country, :subdomain, :logo)
  end


  def company_properties
    params.permit(:properties, :image)
  end


   # set current user and check if use has permissions to access the view
    def set_up_user
        # user's details
        @user = current_user
        @notification = Notification.where(user_id: @user.id, read: 0)
    end

    # set_up company details and check if the user has permission to access the company
    # so user's can't access it from the url
    def set_up_company
        @company = Company.friendly.find(params[:company_id] || params[:id])
        result = JointUserCompany.find_by(user_id: @user.id, company_id: @company.id)
        if result.nil?
           redirect_to user_dashboard_path
        end
    end


end
