class CreateFileUploads < ActiveRecord::Migration
  def change
    create_table :file_uploads do |t|
    	t.string :file_link
    	t.integer :file_type
    	t.belongs_to :user
    	t.belongs_to :interview
      t.timestamps null: false
    end
  end
end
