class AddCompletedMessageToInterviews < ActiveRecord::Migration
  def change
  	add_column :interviews, :completed_message, :string
  end
end
