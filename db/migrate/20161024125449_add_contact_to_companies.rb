class AddContactToCompanies < ActiveRecord::Migration
  def change
  	add_column :companies, :contact, :string
  end
end
