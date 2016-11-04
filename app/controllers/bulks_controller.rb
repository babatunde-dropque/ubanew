class BulksController < ApplicationController
  before_action :set_bulk, only: [:show, :edit, :update, :destroy]






  def index
    @bulks = Bulk.all
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

    respond_to do |format|
      if @bulk.save
        format.html { redirect_to @bulk, notice: 'Contact was successfully created.' }
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
        format.html { redirect_to @bulk, notice: 'Contact was successfully updated.' }
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
      format.html { redirect_to bulks_url, notice: "#{@bulk.name} was successfully deleted." }
      format.json { head :no_content }
    end
  end
  def import
   Bulk.import(params[:file])
   redirect_to bulks_path, notice: "Contacts Successfully Uploaded"
  end

  def fetch
   Bulk.fetch(params[:file])
   redirect_to bulks_path, notice: "Contacts Successfully Uploaded"
  end



  private

    def set_bulk
      @bulk = Bulk.find(params[:id])
    end


    def bulk_params
      params.require(:bulk).permit(:name, :email, :telephone)
    end
end
