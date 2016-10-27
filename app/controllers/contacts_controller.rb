class ContactsController < ApplicationController
  before_action :set_company
  def index
  	@contacts = Contact.all
  end

  def new
  	@contact = Contact.new
  end


  def show
  end

  def create
  	@contact = Contact.new(contact_params)
    # @contact.company_id = @company.id
    @contact.company = @company
  	if @contact.save
  		redirect_to company_contacts_path, notice: "The contact #{@contact.name} has been uploaded."

 else 
	render "new"
 end
end

private
def set_contact
  @contact = Contact.find(params[:id])
end
def set_company
 @company = Company.friendly.find(params[:company_id] || params[:id])
end

def contact_params
	params.require(:contact).permit(:name, :attachment)
	end



  def destroy
  	@contact = Contact.find(params[:id])
  	@contact.destroy
  	redirect_to contacts_path, notice: "The Contact #{@contact} has been deleted."
  end
end
