class AddMoreAttributeToUser < ActiveRecord::Migration
  def change
  	add_column :users, :about_me, :string
  	add_column :users, :skill, :string
  	add_column :users, :school, :string
  	add_column :users, :grade, :string
  	add_column :users, :field_of_study, :string
  end
end
