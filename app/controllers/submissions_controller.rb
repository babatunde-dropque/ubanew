class SubmissionsController < ApplicationController
	layout 'user_dashboard'
	before_action :authenticate_user!
	before_action :set_up_user
  before_action :set_up_company
  before_action :set_up_interview
  before_action :set_up_submission

	def export
	    @submissions = @interview.submissions
	    respond_to do |format|
	      format.html
	      format.csv { send_data @submissions.to_csv(@interview.questions), filename: @interview.title + "-#{Date.today}.csv"  }
	      format.xls
	    end
 	end

def shortlist
  # @id = @submission.id
  if InterviewMailer.shortlist(@interview, @id).deliver
    render plain:  "true"
  else
    render plain: "error"
  end
end

  def reject
   # @id = @submission.id
   if InterviewMailer.reject(@interview, @id).deliver
    render plain: "true"
  else
    render plain:"error"
  end
 end


 private

	def set_up_user
      @user = current_user
      @notification = Notification.where(user_id: @user.id, read: 0)
  end

  def set_up_interview

      @interview = Interview.friendly.find(params[:interview_id] || params[:id])
      # check if company has permission to view the interview
      if !(@interview.company_id == @company.id)
        redirect_to company_path
      end

  end
  def set_up_submission
      # @submission = Submission.last
      @submits = @interview.submissions
       @submits.each do |submit|
        @id = submit.id
      end
  end

	# set_up company details and check if the user has permission to access the company
    # so user's can't access it from the url
    def set_up_company
        @company = Company.friendly.find(params[:company_id] || params[:id])
        result = JointUserCompany.find_by(user_id: @user.id, company_id: @company.id)
        if result.nil?
           redirect_to user_dashboard_path
        end
    end


end
