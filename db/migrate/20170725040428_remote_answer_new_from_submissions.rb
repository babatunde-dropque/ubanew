class RemoteAnswerNewFromSubmissions < ActiveRecord::Migration
  def change
    remove_column :submissions, :answers_new
  end
end
