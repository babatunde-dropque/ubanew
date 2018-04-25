class CreateAivideos < ActiveRecord::Migration
  def change
    create_table :aivideos do |t|
    	t.string :token
    	t.string :description
      t.timestamps null: false
    end
  end
end
