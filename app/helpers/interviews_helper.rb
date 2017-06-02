module InterviewsHelper
	def interview_timeline_data
	 @interview = Interview.friendly.find(params[:interview_id] || params[:id])
     (1.days.ago.to_date..Date.today).map do |date|
     	{
     		Date: date,
     		finish: Submission.where(interview_id:@interview.id, current_no:500).where("updated_at > ?", date).length,
     		unfinish: Submission.where(interview_id:@interview.id,current_no:nil ).where("updated_at > ?", date).length
     	}
     end
	end
	def submission_timeline_data
	 @interview = Interview.friendly.find(params[:interview_id] || params[:id])
     (@interview.created_at.to_date..Date.today).map do |date|
     	{
     		Date: date,
     		all: Submission.where(interview_id:@interview.id).where("updated_at > ?", date).length
     	}
     end
	end



end


