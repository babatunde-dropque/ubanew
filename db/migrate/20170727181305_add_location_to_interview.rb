class AddLocationToInterview < ActiveRecord::Migration
  def change
       	add_column :interviews, :city, :string
        add_column :interviews, :state, :string
        add_column :interviews, :country, :string
  end
end
