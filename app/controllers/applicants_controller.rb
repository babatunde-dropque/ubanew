class ApplicantsController < ApplicationController
  layout 'applicants' 
  # before_action :authenticate_user!, :except[:index]
  before_filter :set_up_company, :except => [:validate_interview]
  before_filter :set_up_interview, :except => [:index, :validate_interview, :submit_video]
  before_filter :set_up_user_and_submission, :except => [:index, :validate_interview, :submit_video]


  def index

    @editable = "false" # disable editable view
    # check details parameter and validate interview token once again
    if params[:page] == "register"
      @interview = Interview.find_by(interview_token: params[:interview_token], company_id: @company.id )
        if !@interview.nil? && !@interview.deadline.nil? && @interview.deadline.to_date.past?
          render "expired"
        elsif !@interview.nil? && @interview.status == "1"
            render "register_private"
        elsif !@interview.nil?
            render "register"
        end
    elsif params[:page] == "details"
      @interview = Interview.find(params[:interview_id])
      # check if user is signed in  or not

      if !user_signed_in?
        redirect_to new_user_session_path(interview_token: @interview.interview_token)
      else
          @user = current_user
          # create submission for user
          if  Submission.exists?(interview_id: @interview.id, user_id: @user.id)
            @submission =   Submission.find_by(interview_id: @interview.id, user_id: @user.id)
            @position = @submission.current_no
          else
             # create new submission
            if  mobile_device?
              device = "1"
            else
              device = "2"
            end
            @submission = Submission.new(user_id: @user.id, interview_id: @interview.id, device: device)
            @submission.save
            @position = 0
          end
          render "details"
      end
    end
  end



  def question
     current_position = ( @submission.current_no.nil? ) ? 0 : @submission.current_no
     @position =  test_for_end(@interview.questions.length, params[:pos].to_i)
     if current_position > @position
        @position = current_position
     end

     if (params[:submission] == "text")
        @submission.update_attributes(current_no: @position, answers: params[:answers])
     end
     render_question_view(@position)
 end 


 def render_question_view(position)
  @editable = "false" # disable editable view
  @position = position
  @number_of_question = @interview.questions.length 
     if @position < @number_of_question 
        @question_type = @interview.questions[@position]["question_type"]
        if  @question_type == "1"
            @question_video = @interview.questions[@position]["question_video"]
            @time_allowed  = @interview.questions[@position]["time_allowed"]
            render "video"
        elsif @question_type == "2"
           @question_text = @interview.questions[@position]["question_text"]
           @max_char = @interview.questions[@position]["max_char"]
           render "text"

        elsif @question_type == "3"
           @file_text = @interview.questions[@position]["file_text"]
           @file_size = @interview.questions[@position]["file_size"]
           render "file"
        end
     else
       render "complete"
     end
 end


 def upload_file
    position = test_for_end(@interview.questions.length, params[:pos].to_i )
    upload = FileUpload.new(file_link: params[:file], file_type: 1, user_id: @user.id, interview_id: @interview.id)
      if upload.save
        @submission.answers << { question_type: "3", file_text: params[:file_text], file_link: upload.file_link.url, file_id: upload.id, file_size: params[:file].size }
        @submission.current_no = position
        @submission.save
        render plain: "success"
      else
        render plain: "error"
      end
end


  def validate_interview
    if  Interview.exists?(interview_token: params[:interview_token])
      render plain: "success"
    else
      render plain: "error"
    end
  end

  # for capturing users device or otherwise
  def mobile_device?
  if session[:mobile_param]
    session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
    end
  end


  # this is a stand alone api
  def submit_video
    # am not just using Submission.find, so that any one can't just modify the submission
    # it has to be the right combination of interview_token and user_id

    # although this will be a little bit slow but way more secure than just accessing by id
    interview = Interview.find_by(interview_token: params[:interview_token])
    position = test_for_end(interview.questions.length, params[:position].to_i )
    submission = Submission.find_by(interview_id: interview.id , user_id: params[:user_id])
    if submission.update_attributes(current_no: position, answers: params[:answers], first_video: params[:position].to_i)
      render plain: "success"
    else
      render plain: "error"
    end
  end


  def test_for_end(length, position)
    if position >= length
      return 500
    elsif length > position
      return position
    end
  end


 
  # this will diable cache from browser
  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
  


  private


  def set_up_company 
    # get subdomain
    subdomain = request.subdomain
    @company = Company.find_by(subdomain: subdomain)
    if @company.nil?
      redirect_to root_path
    end
  end

  def set_up_interview
    @interview = Interview.find(params[:id])
  end 

  def set_up_user_and_submission
    @user = User.find(params[:user_id])
    @submission = Submission.find(params[:submission_id])
  end


end