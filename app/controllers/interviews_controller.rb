class InterviewsController < ApplicationController
	layout 'user_dashboard'
	before_action :authenticate_user!
	before_action :set_up_user
  before_action :set_up_company
  before_action :set_up_interview, :except => [:new, :create, :index]
  # before_action :set_up_submission, :except => [:new, :create, :index]




	def show

	end

	def edit
    render  :layout => 'wizard'
	end


  def single_interview_submissions
     @user_company = JointUserCompany.find_by(user_id: @user.id, company_id: @company.id)
     @user_status = @user_company.status
     @submissions = @interview.submissions.where(current_no: 500, status: nil).paginate(:page => params[:page], :per_page => 24).order('created_at DESC')
     render :layout => 'single_interview_submissions'
  end

  # controller function for to manages interview filtered
def filtered_single_interview
    @user_company = JointUserCompany.find_by(user_id: @user.id, company_id: @company.id)
    @user_status = @user_company.status
    @submissions = @interview.submissions.where(current_no: 500, status: params[:status].to_i).paginate(:page => params[:page], :per_page => 24).order('created_at DESC')
    @meg =  params[:status].to_i
    if (@meg == 0 )
      @peg = "Shortlist"
      @prefiled_mes = "In response to the  Interview you took with our company, we  glad to inform you  have been shorlisted"
     elsif(@meg == 2)
      @peg = "Reject"
      @prefiled_mes = "Thank you for taking interview with us.
                        However, you did not make the final list
                        We wish you   best  in future endeavors"
    end
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
          if submission.answers[question_number]["answer_id"].nil?  
         render :json => {:answer => submission.answers[question_number]["answer_text"],:question => submission.answers[question_number]["question_text"] }
          else
         text_result = TextUpload.find(submission.answers[question_number]["answer_id"])
         render :json => {:answer => text_result.text , :question => submission.answers[question_number]["question_text"] }
          end
      elsif question_type == "3"
         render :json =>{:answer => submission.answers[question_number]["file_link"], :question => submission.answers[question_number]["file_text"], :file_size => submission.answers[question_number]["file_size"] } 
      end
    else
      render plain: "error"
    end
  end


  def new
    @interview = Interview.new
    @new_interview = true
     render  :layout => 'wizard'
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
	end



	def create
		interview = Interview.new(interview_params)
    # send_bulk_invite_mail(params[:contacts])
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

  def destroy
    @interview = Interview.friendly.find(params[:id])
    @interview.destroy
    redirect_to company_interviews_path, notice: "The  Interview #{@interview.title} has been deleted."
  end



  def send_invite_mail
     mail_list = params[:mail_list]
     list = mail_list.split(",")
     list.map do |item|
        InterviewMailer.interview_invite(@interview, item, request.domain ).deliver
     end
     redirect_to  company_interview_path(company_id:@company.slug, id:@interview.id), notice: 'Invitation was successfully sent.'
  end

  def analytics
    @all_submissions = Submission.where(interview_id:@interview.id)
    @unfinish  = Submission.where(interview_id:@interview.id).where(current_no:nil)
    @finish  = Submission.where(interview_id:@interview.id).where(current_no:500)
    @mobile = Submission.where(interview_id:@interview.id).where(device:1)
  end

  def fetchLineData

  end


def reminder
      if !@interview.deadline.nil? && !@interview.deadline.to_date.past?
          Submission.where(interview_id:@interview.id).where("current_no < ? or current_no is NULL", 500).each do |me|
          ReminderMailer.reminder(me.user.email, me.user.name, @interview).deliver
        end
      end
      redirect_to  company_interview_path(company_id:@company.slug, id:@interview.id), notice: 'Reminder was successfully sent.'
end


   def sms_reminder
       if !@interview.deadline.nil? && !@interview.deadline.to_date.past?
            Submission.where("interview_id = ?", @interview.id).where("current_no < ?", 500).find_each do |me|
            Interview.sms_reminder(@company, @interview, User.find(me.user_id).telephone, User.find(me.user_id).name)
            #ReminderMailer.reminder(User.find(me.user_id).telephone, @interview).deliver
         end
       end
      redirect_to  company_interview_path(company_id:@company.slug, id:@interview.id), notice: 'SMS Reminder was successfully sent.'
   end


   def double_reminder
       if !@interview.deadline.nil? && !@interview.deadline.to_date.past?
            Submission.where("interview_id = ?", @interview.id).where(current_no:nil).find_each do |me|
            ReminderMailer.reminder(User.find(me.user_id).email, @interview).deliver
            Interview.sms_reminder(@company, @interview, User.find(me.user_id).telephone, User.find(me.user_id).name)
            #ReminderMailer.reminder(User.find(me.user_id).telephone, @interview).deliver
         end
       end
      redirect_to  company_interview_path(company_id:@company.slug, id:@interview.id), notice: 'SMS Reminder was successfully sent.'
   end


  def unfinish_submission
      @unfinish_submissions = @interview.submissions.where("current_no < ?", 500)
      render :layout => 'single_interview_submissions'
  end

def mass_notify
      set =     params[:set]
      subject = params[:subject]
      body =    params[:body]
   if( set == "Shortlist")
          Submission.where(interview_id:@interview.id).where(status:0).find_each do |me|
          InterviewMailer.mass_shortlist(me.id, @interview, subject, body ).deliver
          end
         elsif(set == "Reject")
         rejects = Submission.where(interview_id:@interview.id).where(status:2)
         rejects.find_each do |reject|
         InterviewMailer.mass_reject(reject.id, @interview, subject, body ).deliver!
        end
   end
  render :layout => 'single_interview_submissions'
end



  def change_status
      submission = Submission.find(params[:submission_id])
       # InterviewMailer.shortlist(@interview, 2).deliver
     if submission.update(status: params[:status].to_i) && submission.status == "shortlist"
        render plain: "shortlist"
     elsif submission.update(status: params[:status].to_i) && submission.status == "pend"
        render plain: "pend"
     elsif submission.update(status: params[:status].to_i) && submission.status ==  "reject"
        # InterviewMailer.reject(@interview, 1).deliver
        render plain: "reject"
     else
        render plain: "error"
     end
  end


  # def get_price(time_in_sec, currency)
  #   if currency == "NGN"
  #     if (time_in_sec < )

  #     elsif (time_in_sec < )

  #     else (time_in_sec < )

  #   elsif currency == "USD"

  #   end
  # end


  # def pricing
  #   all_submission = @interview.submissions
  #   question_length =  all_submission.length
  #   prices = {}
  #   question_length.times do |i|
  #       prices[i] = 0
  #   end

  #   # loop through all the available videos
  #   all_submission.each do | submission |
  #     sum = 0
  #     submission.answers.each do | answer |
  #       if answer["question_type"] != nil && answer["question_type"] == 1
  #         sum =+ 1
  #         price = get_price((15000/1000), "NGN")
  #         prices[1]=+
                 
  #       end

       

  #     end

  #   end
  #   NGN = {2.5: 50, 3: 75, }
  #   USD = {}


  # end





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
           self.dashboard_function()
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
                                  :city,
                                  :state,
                                  :country
                                  )
    end
end
