class AddSocialToUser < ActiveRecord::Migration
  def change
        add_column :users, :social, :json
  end
end
