class InterviewsController < ApplicationController
	layout 'user_dashboard'
	before_action :authenticate_user!
	before_filter :set_up_user
  before_filter :set_up_company
  before_action :set_up_interview, :except => [:new, :create, :index]



	def show

	end

	def edit

	end

  def single_interview_submissions
     @submissions = @interview.submissions.where(current_no: 500)
     render :layout => 'single_interview_submissions'
  end

  # controller function for to manages interview filtered
  def filtered_single_interview
    @submissions = @interview.submissions.where(current_no: 500, status: params[:status].to_i)
    render :action => 'single_interview_submissions', :layout => 'single_interview_submissions'
  end

  # api for return text or file link
  def returnTextFileApi
    question_type = params[:question_type]
    question_number = params[:question_number].to_i
    submission_id = params[:submission_id]
    submission = Submission.find(submission_id)
    if !submission.nil? && submission.answers[question_number]["question_type"] == question_type
      if question_type == "2"
         render :json => {:answer => submission.answers[question_number]["answer_text"],:question => submission.answers[question_number]["question_text"] }
      elsif question_type = "3"
         render :json =>{:answer => submission.answers[question_number]["file_link"], :question => submission.answers[question_number]["file_text"], :file_size => submission.answers[question_number]["file_size"] } 
      end 
    else 
      render plain: "error"     
    end
  end


	def new
		@interview = Interview.new
    @new_interview = true

	end


  def update

    respond_to do |format|
      if @interview.update(interview_params)
          format.html { redirect_to company_interview_path(id: @interview.id), notice: 'Interview was successfully updated.' }
          format.json { render :show, status: :ok, location: @interview }
      else
        format.html { render :edit }
        format.json { render json: @interview.errors, status: :unprocessable_entity }
      end
    end

  end

	def index
		@interview_all = @company.interviews
		# @interview_all = Interview.where(company_id: @company.id)

	end

	def create
		interview = Interview.new(interview_params)
    send_bulk_invite_mail(params[:contacts])
    puts interview_params[:status]
	    interview.company = @company
	    respond_to do |format|
	      if interview.save
	        format.html { redirect_to company_interview_path(id: interview.slug), notice: 'Interview was successfully created.' }
	        format.json { render :show, status: :created, location: interview }
	      else
	        format.html { render :new }
	        format.json { render json: interview.errors, status: :unprocessable_entity }
	      end
	    end
	end

  def send_invite_mail
      InterviewMailer.interview_invite(@interview, "mustaphaalade@gmail.com").deliver
    #  @int = Interview.find(params[:interview_id])
    #  @list = @int.mail_list.split(",")
    #  @list.map do |item|
    # InterviewMailer.interview_invite(@int, item).deliver
    # end
    respond_to do |format|
      format.html { redirect_to company_interview_path(id: @interview.slug), notice: 'Interview was successfully sent.' }
    end
  end


	private

	def set_up_user
      @user = current_user
      @notification = Notification.where(user_id: @user.id, read: 0)
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

    def set_up_interview
    	@interview = Interview.last
    	# check if company has permission to view the interview
    	if !(@interview.company_id == @company.id)
    		redirect_to company_path
    	end

    end

	# Never trust parameters from the scary internet, only allow the white list through.
    def interview_params
      params.require(:interview).permit(:title,
                                  :description,
                                  :deadline,
                                  :tags,
                                  :instruction,
                                  :mail_list,
                                  :questions,
                                  :shortlist_message,
                                  :reject_message,
                                  :invite_message,
                                  :status,
                                  :completed_message,
                                  )
    end
end
