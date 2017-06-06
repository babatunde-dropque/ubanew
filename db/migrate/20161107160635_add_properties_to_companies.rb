class AddPropertiesToCompanies < ActiveRecord::Migration
  def change
  	add_column :companies, :properties, :json
  end
end
