class CreateTextUploads < ActiveRecord::Migration
  def change
    create_table :text_uploads do |t|
      t.string :text
      t.belongs_to :user
      t.belongs_to :submission
      t.belongs_to :interview
      t.timestamps null: false
   end
  end
end
 

