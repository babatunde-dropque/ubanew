class CreateInterviews < ActiveRecord::Migration
  def change
    create_table :interviews do |t|
    	t.string :title
    	t.text	 :description
    	t.string :salary_range
    	t.datetime :deadline
    	t.string	:tags
    	t.json 		:questions
    	t.text		:instruction
    	t.text		:mail_list
    	t.string	:interview_token
    	t.text		:shortlist_message
    	t.text		:invite_message
    	t.text		:reject_message
    	t.belongs_to :company
      t.timestamps null: false
    end
  end
end



