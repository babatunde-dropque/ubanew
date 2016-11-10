class BulksController < ApplicationController
  layout 'user_dashboard'
  before_action :authenticate_user!
  before_filter :set_up_user
  before_action :set_company
  before_action :set_group
  before_action :set_bulk, only: [:show, :edit, :update, :destroy]
  

  def index
      @bulks = @group.bulks
      # @count = @bulk.length
 end


  def show

  end

  def new
    @bulk = Bulk.new
  end

  def edit

  end


  def create
    @bulk = Bulk.new(bulk_params)
    @bulk.group = @group
    respond_to do |format|
      if @bulk.save
        format.html { redirect_to company_group_bulks_path, notice: 'Contact was successfully created.' }
        format.json { render :show, status: :created, location: @bulk }
      else
        format.html { render :new }
        format.json { render json: @bulk.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    respond_to do |format|
      if @bulk.update(bulk_params)
        format.html { redirect_to company_group_bulks_path, notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @bulk }
      else
        format.html { render :edit }
        format.json { render json: @bulk.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @bulk = Bulk.find(params[:id])
    @bulk.destroy
    respond_to do |format|
      format.html { redirect_to company_group_bulks_url, notice: "#{@bulk.name} was successfully deleted." }
      format.json { head :no_content }
    end
  end

  def import
   Bulk.import(params[:file])
    # bulk.group_id = @group.id
   redirect_to company_group_bulks_path, notice: "Contacts Successfully Uploaded"
  end

  def fetch
   Bulk.fetch(params[:file])
   redirect_to bulks_path, notice: "Contacts Successfully Uploaded"
  end

  private
  def set_up_user
      @user = current_user
      @notification = Notification.where(user_id: @user.id, read: 0)
  end


  # check if the group has permission to access the bulk file
  def set_bulk
    @bulk = Bulk.find(params[:id])
    if !(@bulk.group_id == @group.id)
      redirect_to company_group_bulks_path
    end
  end

  #  check if the company has permission to access the group
  def set_group
    @group = Group.friendly.find(params[:group_id] || params[:id])
    $grou = @group.id
    # check if company has permission to view the group
    if !(@group.company_id == @company.id)
      redirect_to company_path(@company.slug)
    end
  end

  # check if the user has permission to access the company
  def set_company
      @company = Company.friendly.find(params[:company_id] || params[:id])
      result = JointUserCompany.find_by(user_id: @user.id, company_id: @company.id)
      if result.nil?
         redirect_to user_dashboard_path
      end
  end


    def bulk_params
      params.require(:bulk).permit(:name, :email, :telephone)
    end
end
