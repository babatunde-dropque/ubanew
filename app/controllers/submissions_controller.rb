class SubmissionsController < ApplicationController
	layout 'user_dashboard'
	before_action :authenticate_user!
	before_action :set_up_user
    before_action :set_up_company
    before_action :set_up_interview

	def export
	    @submissions = @interview.submissions
	    respond_to do |format|
	      format.html
	      format.csv { send_data @submissions.to_csv(@interview.questions), filename: @interview.title + "-#{Date.today}.csv"  }
	      format.xls 
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
