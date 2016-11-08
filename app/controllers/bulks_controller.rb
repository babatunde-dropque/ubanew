class BulksController < ApplicationController
  before_action :set_bulk, only: [:show, :edit, :update, :destroy]
  # devise_group :person, contains: [:company]
  # before_action :authenticate_person!, except: [:create, :new]
  # before_filter :set_up_user
  before_action :set_company
  before_action :set_group

  def index
    # if company_signed_in?
      @company = Company.friendly.find(params[:company_id])
      @group = Group.find(params[:group_id])
      @bulks = Bulk.where(group_id: @group.id)
      # @count = @bulk.length
   # end
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



    def set_bulk
      @bulk = Bulk.find(params[:id])
    end

   # def set_current_group
   #  #  set @current_account from session data here
   #  @current_group = Group.find_by(id: params[:group_id])
   #  Group.current = @current_group
   # end

    def set_group
      @group = Group.find_by(id: params[:group_id])
      $grou = @group.id
    end

    def set_company
     @company = Company.find_by(id: params[:company_id])
    end


    def bulk_params
      params.require(:bulk).permit(:name, :email, :telephone)
    end
end
