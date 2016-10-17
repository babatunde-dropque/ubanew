class CompaniesController < ApplicationController
	layout 'user_dashboard'
	before_action :authenticate_user!
    before_filter :set_up_user


    def set_up_user
        @user = current_user
        @notification = Notification.where(user_id: @user.id, read: 0)
    end

	def dashboard
        @company = Company.friendly.find(params[:company_id])
        @user_status = JointUserCompany.find_by(user_id: @user.id, company_id: @company.id)
        @sigin_in_count = current_user.sign_in_count.to_s
        # @interviews = @company.interviews.includes(:users).where(submissions: {status: nil}).paginate(:page => params[:page], :per_page => 5) 
	end

	def new
		
		
	end

    def add_collaborators
        @company = Company.friendly.find(params[:company_id] || params[:id])
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
        @company = Company.friendly.find(params[:company_id] || params[:id])
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
         @company = Company.friendly.find(params[:company_id] || params[:id])
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
        @company = Company.friendly.find(params[:company_id] || params[:id]) 
        @user_company = JointUserCompany.find_by(user_id: @user.id, company_id: @company.id) 
        @collborators = @company.joint_user_companies
        @user_status = @user_company.status
    end


    def update 
        @company = Company.friendly.find(params[:company_id] || params[:id])   
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

	def show

	end


  private

  def create_company_params
    params.permit(:name, :description, :tags, :image, :city, :address, :country, :subdomain)
  end


end
