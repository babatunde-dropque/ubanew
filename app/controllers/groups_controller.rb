class GroupsController < ApplicationController
  layout 'user_dashboard'
  before_action :authenticate_user!
  before_action :set_up_user
  before_action :set_company
  before_action :set_group , :except => [:new, :create, :index]


  def index
  	@groups = @company.groups
  end

  def new
  	@group = Group.new
  end


  def show

  end




  def create
    	@group = Group.new(group_params)
       # @group.company_id = @company.id
       @group.company = @company

    	if @group.save
    		 redirect_to company_groups_path, notice: "The group #{@group.name} has been uploaded."
      else
    	   render "new"
      end
  end

  def destroy
    @group = Group.friendly.find(params[:id])
    @group.destroy
    redirect_to company_groups_path, notice: "The  contact group #{@group.name} has been deleted."
  end


  def show_group_emails
    contact = @group.bulks
    render :json => contact.as_json(:only => [:email])
  end


private
      def set_group
        @group = Group.friendly.find(params[:group_id] || params[:id])
        # check if company has permission to view the interview
        if !(@group.company_id == @company.id)
          redirect_to company_path
        end

    end

    def set_company
        @company = Company.friendly.find(params[:company_id] || params[:id])
        result = JointUserCompany.find_by(user_id: @user.id, company_id: @company.id)
        if result.nil?
           redirect_to user_dashboard_path
        end
    end

    def group_params
  	   params.require(:group).permit(:name, :auto_response)
  	end

    def set_up_user
        @user = current_user
        @notification = Notification.where(user_id: @user.id, read: 0)
    end

end
