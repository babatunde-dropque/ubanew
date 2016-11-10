class GroupsController < ApplicationController

# layout 'dashboard'
  before_filter :set_up_user
  # before_filter :set_current_group
  before_action :set_company
  # before_filter :set_current_group

  def index
  	@groups = Group.all
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
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to company_groups_path, notice: "The  contact group #{@group.name} has been deleted."
  end

   # def set_current_group
   #  #  set @current_account from session data here
   #  @current_group = Group.find_by(id: params[:group_id])
   #  Group.current = @current_group
   # end


   def set_group
    @group = Group.find(params[:id])
   end

  def set_company
    @company = Company.friendly.find(params[:company_id] || params[:id])
  end

  def group_params
	   params.require(:group).permit(:name, :auto_response)
	end

  def set_up_user
        @user = current_user
        @notification = Notification.where(user_id: @user.id, read: 0)
  end

end
