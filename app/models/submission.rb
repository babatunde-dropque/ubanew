class Submission < ActiveRecord::Base
	# attr_accessible :name, :price, :released_on

	belongs_to :interview
	belongs_to :user
	enum status: [:shortlist, :pend, :reject]


	# allow user to be able to commend on this model
	acts_as_commontable
	ratyrate_rateable "response"

  
	def self.to_csv(questions)
	@length = questions.length
    CSV.generate do |csv|
      csv.add_row  [:Name, :Email, :Progress, :Status, :Date]
      all.each do |submission|
      	single = []
      	if !submission.user.nil?
  		  single.push(submission.user.name)
  		  single.push(submission.user.email)
  		else
  			single.push("","")
  		end 

  		if submission.current_no == 500
	       single.push("Completed")
	    elsif submission.current_no.nil?
	       single.push("0%")
	    else
	       value = (submission.current_no + 1)/ @length
	       single.push(value.to_s+"%")
	    end 

	    if submission.status.nil? 
	     	single.push("Non")
	    elsif submission.status == 'reject'
	      single.push("Reject")
	    elsif submission.status == 'pend'
	      single.push("Pend")
	    elsif submission.status == 'shortlist'
	      single.push("Shorlist")
	    end 

        single.push(submission.created_at.strftime("%d-%m-%Y"))
      	csv.add_row single
      end
    end

  end


	# def self.to_csv(options = {})
 #    CSV.generate(options) do |csv|
 #      csv << column_names
 #      all.each do |submission|
 #        csv << submission.attributes.values_at(*column_names)
 #      end
 #    end

 #  end
	

	 

end
