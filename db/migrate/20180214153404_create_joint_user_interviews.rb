class CreateJointUserInterviews < ActiveRecord::Migration
  def change
    create_table :joint_user_interviews do |t|
      t.integer :status
      t.belongs_to :user 
      t.belongs_to :interview
      t.timestamps null: false

    end
  end
end
