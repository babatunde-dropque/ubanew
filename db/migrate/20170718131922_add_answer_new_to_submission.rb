class AddAnswerNewToSubmission < ActiveRecord::Migration
  def change
       	add_column :submissions, :answers_new, :text
  end
end
