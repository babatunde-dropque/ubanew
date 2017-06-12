class RemoveAnswerFromSubmissions < ActiveRecord::Migration
  def change
  	remove_column :submissions, :answer
  	add_column :submissions, :answers, :string
  end
end
