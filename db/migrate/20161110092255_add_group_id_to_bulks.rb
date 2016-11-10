class AddGroupIdToBulks < ActiveRecord::Migration
  def change
  	add_reference :bulks, :group
  end
end
