class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
    	t.string :message
    	t.integer :read
    	t.integer :type_notification
    	t.belongs_to :user

      t.timestamps null: false
    end
  end
end
