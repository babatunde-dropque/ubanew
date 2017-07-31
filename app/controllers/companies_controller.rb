require 'slack-notifier'
class CompaniesController < ApplicationController
	layout 'user_dashboard'
	before_action :authenticate_user!
    before_filter :set_up_user
    before_filter :set_up_company, :except => [:new, :create, :check_subdomain ]



	def show
        if params[:from_notification].present?
            @user.update_attributes(last_company: @company.id)
        end
        @user_status = JointUserCompany.find_by(user_id: @user.id, company_id: @company.id)
        @sigin_in_count = current_user.sign_in_count.to_s
        @all_interview = @company.interviews
	end

	def new
        @profile_page = true
        render  :layout => 'wizard'
	end


    def preview

    end

    def card_preview

    end

    def search_talent
            @sure_applicants = User.where(status:0)
            @unsure_applicants = User.where(status:nil)
            @applicants = @sure_applicants.merge(@unsure_applicants)
            @search_category = ['Skill', 'Descipline', 'Grade', 'City', 'School']
        if  params[:search].present? && params[:category].present? && !params[:search2].present? && !params[:search3].present?
            @query = params[:search]
            #@field = assign_field(params[:category])
            @talent = @applicants.where("lower(#{params[:category]}) LIKE ?", "%#{params[:search].downcase}%").paginate(:page => params[:page], :per_page => 10)
            elsif params[:search2].present? && params[:category2].present? && !params[:search].present? && !params[:search3].present?
                @query = params[:search2]
                #@field = assign_field(params[:category])
                @talent = @applicants.where("lower(#{params[:category2]}) LIKE ?", "%#{params[:search2].downcase}%").paginate(:page => params[:page], :per_page => 10)
            elsif params[:search3].present? && params[:category3].present? && !params[:search].present? && !params[:search2].present?
                @query = params[:search3]
                #@field = assign_field(params[:category])
                @talent = @applicants.where("lower(#{params[:category3]}) LIKE ?", "%#{params[:search3].downcase}%").paginate(:page => params[:page], :per_page => 10)
            elsif params[:search].present? && params[:category].present? && params[:search2].present? && params[:category2].present? && !params[:search3].present?
                @query = params[:search3]
                #@field = assign_field(params[:category])
                @talent = @applicants.where("lower(#{params[:category]}) LIKE ?", "%#{params[:search].downcase}%").where("lower(#{params[:category2]}) LIKE ?", "%#{params[:search2].downcase}%").paginate(:page => params[:page], :per_page => 10)
            elsif params[:search].present? && params[:category].present? && params[:search3].present? && params[:category3].present? && !params[:search2].present?
                @query = params[:search3]
                #@field = assign_field(params[:category])
                @talent = @applicants.where("lower(#{params[:category]}) LIKE ?", "%#{params[:search].downcase}%").where("lower(#{params[:category3]}) LIKE ?", "%#{params[:search3].downcase}%").paginate(:page => params[:page], :per_page => 10)

           elsif params[:search2].present? && params[:category2].present? && params[:search3].present? && params[:category3].present? && !params[:search].present?
                @query = params[:search3]
                #@field = assign_field(params[:category])
                @talent = @applicants.where("lower(#{params[:category2]}) LIKE ?", "%#{params[:search2].downcase}%").where("lower(#{params[:category3]}) LIKE ?", "%#{params[:search3].downcase}%").paginate(:page => params[:page], :per_page => 10)
          elsif params[:search].present? && params[:category].present? && params[:search2].present? && params[:category2].present? && params[:search3].present? && params[:category3].present?
                @query = params[:search3]
                #@field = assign_field(params[:category])
                @talent = @applicants.where("lower(#{params[:category]}) LIKE ?", "%#{params[:search].downcase}%").where("lower(#{params[:category2]}) LIKE ?", "%#{params[:search2].downcase}%").where("lower(#{params[:category3]}) LIKE ?", "%#{params[:search3].downcase}%").paginate(:page => params[:page], :per_page => 10)

     end
    end




    def assign_field (val)
        if val == "Skill"
            return "skill"
               elsif val == "Field"
                    return "field_of_study"
                elsif val == "Grade"
                    return "grade"
                elsif val == "Location"
                    return "city"
                elsif val == "School"
                    return "school"
        end
    end

    def show_talent
        @profile_page = true
        @logo_off = false
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



    def check_subdomain
        if  Company.exists?(subdomain: params[:subdomain])
          render plain: "yes"
        else
          render plain: "no"
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

            # send notification to slack
            if Rails.env.production?
                notifier = Slack::Notifier.new "https://hooks.slack.com/services/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", channel: '#notification', username: 'NewOrganization'
                notifier.ping "New organization ("+  company.name + ") by " + current_user.name + "\n" +
                              "email: " + current_user.email + "\n" +
                              "subdomain: " + company.subdomain + "\n" +
                              "Tumbs up guys, getting better. Thanks Dropque Bot"
            end 
            # end of slack notification
            current_user.update_attributes(status:params[:status])
        	redirect_to  company_path(company)
        else

        end
	end




  private

  def create_company_params
    params.permit(:name, :description, :tags, :image, :city, :address, :email, :country, :subdomain, :logo)
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
           self.dashboard_function()
        end
    end


end
