class AddFirstVideoToSubmissions < ActiveRecord::Migration
  def change
  	add_column :submissions, :first_video, :integer
  end
end
