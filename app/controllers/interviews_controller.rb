class InterviewsController < ApplicationController
	layout 'user_dashboard'
	before_action :authenticate_user!
	before_filter :set_up_user
  before_filter :set_up_company
  before_filter :set_up_interview, :except => [:new, :create, :index]



	def show

	end

	def edit

	end

	def new
		@interview = Interview.new

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
	        format.html { redirect_to company_interview_path(id: interview.id), notice: 'Interview was successfully created.' }
	        format.json { render :show, status: :created, location: interview }
	      else
	        format.html { render :new }
	        format.json { render json: interview.errors, status: :unprocessable_entity }
	      end
	    end
	end


	private

	def set_up_user
        @user = current_user
        @notification = Notification.where(user_id: @user.id, read: 0)
  end

  def send_bulk_invite_mail
     @int = Interview.find(params[:interview_id])
     # @listo = File.open(@int.contact, "r")
     @list = @listo.split(",")
     @list.map do |item|
    InterviewMailer.interview_invite(@int, item).deliver
    end
    respond_to do |format|
      format.html {redirect_to company_interview_path_path(id: @int.id), notice: 'Your interview invite has been sent to the Group'}
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

    def set_up_interview
    	@interview = Interview.friendly.find(params[:interview_id] || params[:id])
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
