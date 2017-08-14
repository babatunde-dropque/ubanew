class AlterUserSchoolToJson < ActiveRecord::Migration
  def change
    remove_column :users, :school
    add_column :users, :educations, :json
  end
end
