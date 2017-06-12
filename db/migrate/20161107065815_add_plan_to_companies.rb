class AddPlanToCompanies < ActiveRecord::Migration
  def change
  	add_column :companies, :plan, :integer
  end
end
