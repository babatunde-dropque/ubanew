class InterviewMailer < ApplicationMailer


  def welcome_email(user)
    @user = user
    @name = @user.name
    @dashboard  = 'http://www.dropque.com/dashboard'
    @dropque = "Dropque Inc"
    mail(from: 'Dropque', to: @user.email , subject: 'Welcome to Dropque')
  end

  def interview_invite(interview, email)
    @interview = interview
    @token = @interview.interview_token
    @company = interview.company
    @company_email = @company.email
    @interview_page = "https://#{@company.subdomain}.dropque.com/applicants/#{@token}"
    @company_img = @company.logo
    @url = 'https://www.dropque.com'
    @app = 'https://bit.ly/dropqueapp'
   mail(from:"Invite@dropque.com", to: email, subject: "#{@interview.title} Interview Invitation")
  end


  def shortlist(interview, submissionId)
    @id = submissionId
    @submission = Submission.find_by(id:@id)
    @candidate = User.find(@submission.user_id).name
    @interview = interview
    @email = User.find(@submission.user_id).email
    @company = interview.company
    @company_email = @company.email
    @company_img = @company.logo
    @interview_page = @company.subdomain
    @url = 'https://www.dropque.com'
    @app = 'https://bit.ly/dropqueapp'
    mail(from:"application@dropque.com",to: @email, subject: "#{@interview.title} Interview Outcome")
  end


  def reject(interview, submissionId)
    @id = submissionId
    @submission = Submission.find_by(id:@id)
    @candidate = User.find(@submission.user_id).name
    @interview = interview
    @email = User.find(@submission.user_id).email
    @company = interview.company
    @company_email = @company.email
    @company_img = @company.logo
    @interview_page = @company.subdomain
    @url = 'https://www.dropque.com'
    @app = 'https://bit.ly/dropqueapp'
    mail(from:"application@dropque.com",to: @email, subject: "#{@interview.title} Interview Outcome")
  end
end
