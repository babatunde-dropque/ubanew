class CreateJointUserCompanies < ActiveRecord::Migration
  def change
    create_table :joint_user_companies do |t|
    	t.integer :status
    	t.belongs_to :user  
		t.belongs_to :company

      t.timestamps null: false
    end
  end
end
