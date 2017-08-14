class ChangeUserEducationDefault < ActiveRecord::Migration
  def change
    change_column_default :users, :educations, [] 
  end
end
