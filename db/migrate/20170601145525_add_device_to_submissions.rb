class AddDeviceToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :device, :integer
  end
end
