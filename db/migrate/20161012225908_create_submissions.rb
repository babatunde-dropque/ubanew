class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
    	t.integer :status
    	t.string  :videos
    	t.string   :ziggeo
    	t.string   :ziggeo_flag
    	t.string 	:question_text
    	t.string 	:time_allowed
    	t.belongs_to :user
    	t.belongs_to :interview
    	

      t.timestamps null: false
    end
  end
end
