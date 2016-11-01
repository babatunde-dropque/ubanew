class ApplicantsController < ApplicationController
  layout 'applicants'
  before_filter :set_up_company, :except => [:validate_interview, :validate_email]
  before_filter :set_up_interview, :except => [:index, :validate_interview, :validate_email, :submit_video]
  before_filter :set_up_user_and_submission, :except => [:index, :validate_interview, :validate_email, :submit_video]

  
  def index
  	# check details parameter and validate interview token once again
  	if params[:page] == "register"
      @interview = Interview.find_by(interview_token: params[:interview_token], company_id: @company.id )
        if !@interview.nil?
            render "register"
        end 
    elsif params[:page] == "details"
      @interview = Interview.find(params[:interview_id])
      # check if user exit or not
      if (params[:create] == "yes")

        @user = User.new(name: params[:name], email: params[:email], password: 'dropque')
        @user.save
        
      elsif (params[:create] == "no")
        @user = User.find_by(email: params[:email])
        puts "user ID here"
        puts @user.id
        puts @user.name
        puts "user ID here"
      end

      # create submission for user
      if  Submission.exists?(interview_id: @interview.id, user_id: @user.id)
        @submission =   Submission.find_by(interview_id: @interview.id, user_id: @user.id)
        @position = @submission.current_no
      else
         # create new submission
        @submission = Submission.new(user_id: @user.id, interview_id: @interview.id)
        @submission.save
        @position = 0
      end
      render "details"
    end
  
  	# render default index.html.erb
  end

   # also check if the deadline has been reached
      # also confirm the interview token belongs to the company
      # check if user exist and create if not
      # if User.exists?(email: params[:email])
      
    #   else
    
    #   end

     # create new user


  def question
     @position =  test_for_end(@interview.questions.length, params[:pos].to_i)
     if (params[:submission] == "text")
        @submission.update_attributes(current_no: @position, answers: params[:answers])
     end
     render_question_view(@position)
 end 

 def upload_file
    position = test_for_end(@interview.questions.length, params[:pos].to_i )
    upload = FileUpload.new(file_link: params[:file], file_type: 1, user_id: @user.id, interview_id: @interview.id)
      if upload.save 
        @submission.answers << { question_type: "3", file_text: params[:file_text], file_link: upload.file_link.url, file_id: upload.id }
        @submission.current_no = position
        @submission.save 
        render plain: "success"
      else
        render plain: "error"
      end

 end


 def render_question_view(position)
  @position = position
     if @position < @interview.questions.length 
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




  def validate_interview
    if  Interview.exists?(interview_token: params[:interview_token])
      render plain: "success"
    else
      render plain: "error"
    end 
  end

  def validate_email
    if  User.exists?(email: params[:email])
      render plain: "success"
    else
      render plain: "error"
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
    if submission.update_attributes(current_no: position, answers: params[:answers])
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