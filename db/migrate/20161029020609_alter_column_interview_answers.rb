class AlterColumnInterviewAnswers < ActiveRecord::Migration
  def change
  	change_column :submissions, :answers, 'json USING CAST(answers AS json)'
  end
end
