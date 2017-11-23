class AddSlugToInterviews < ActiveRecord::Migration
  def change
  	add_column :interviews, :slug, :string
    add_index :interviews, :slug, :unique => true
  end
end
