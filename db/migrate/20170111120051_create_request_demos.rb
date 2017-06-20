class CreateRequestDemos < ActiveRecord::Migration
  def change
    create_table :request_demos do |t|
    	t.string :name
    	t.string :email
    	t.string :organization
    	t.string :role
    	t.string :purpose
    	t.string :additional_message

      t.timestamps null: false
    end
  end
end
