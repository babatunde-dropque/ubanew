class AddAnswerToSubmissions < ActiveRecord::Migration
  def change
  	add_column :submissions, :answer, :string
  end
end
