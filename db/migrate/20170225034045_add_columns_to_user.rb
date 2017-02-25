class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :a_qualification, :string
    add_column :users, :a_experience, :integer
    add_column :users, :a_dp, :string
    add_column :users, :a_gender, :string
    add_column :users, :a_dob, :datetime
    add_column :users, :a_cv, :string
  end
end
