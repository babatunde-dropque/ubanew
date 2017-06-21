class AddLastCompanyToUser < ActiveRecord::Migration
  def change
  	add_column :users, :last_company, :string
  end
end
