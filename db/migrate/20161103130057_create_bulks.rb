class CreateBulks < ActiveRecord::Migration
  def change
    create_table :bulks do |t|
      t.string :name
      t.string :email
      t.string :telephone

      t.timestamps null: false
    end
  end
end
