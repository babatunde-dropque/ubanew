class AddApproveToInterviews < ActiveRecord::Migration
  def change
  	 add_column :interviews, :approve, :integer, :default => 0
  end
end
