class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :auto_response

      t.timestamps null: false
    end
  end
end
