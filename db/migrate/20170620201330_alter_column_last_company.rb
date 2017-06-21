class AlterColumnLastCompany < ActiveRecord::Migration
  def change
  	change_column :users, :last_company, 'integer USING CAST(last_company AS integer)'
  end
end
