class AddDetailsToUser < ActiveRecord::Migration
  def change
        add_column :users, :occupation, :string
        add_column :users, :profile_access, :integer
        add_column :users, :marital_status, :integer
        remove_column :users, :grade
  end
end
