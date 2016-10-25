class AlterColumnInterviewStatus < ActiveRecord::Migration
  def change
  	change_column :interviews, :status,  :string
  end
end
