class RanameFieldOfStudyToDiscipline < ActiveRecord::Migration
  def change
  	rename_column :users, :field_of_study, :descipline
  end
end
