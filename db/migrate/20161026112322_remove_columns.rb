class RemoveColumns < ActiveRecord::Migration
  def change
  	remove_column :submissions, :videos
  	remove_column :submissions, :ziggeo
  	remove_column :submissions, :ziggeo_flag
  	remove_column :submissions, :question_text
  	remove_column :submissions, :time_allowed
  	add_column 	  :submissions, :current_no, :integer
  end
end

