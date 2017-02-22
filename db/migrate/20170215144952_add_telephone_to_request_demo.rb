class AddTelephoneToRequestDemo < ActiveRecord::Migration
  def change
    add_column :request_demos, :telephone, :string
  end
end
