class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
    	t.string :name
    	t.string :description
    	t.string :tags
    	t.string :image
    	t.string :city
    	t.string :address
    	t.string :country
    	t.string :slug
    	t.belongs_to :user
    	t.timestamps null: false
    end
  end
end
