class InterviewMailer < ApplicationMailer
  default from: "invite@dropque.com"


  def interview_invite(interview, email)
    @interview = interview
    @token = @interview.interview_token
    @company = interview.company
    @interview_page = "https://#{@company.subdomain}/applicants/#{@token}"
    @company_img = @company.image
    @url = 'https://www.dropque.com'
    @app = 'https://bit.ly/dropqueapp'
   mail(to: email, subject: "#{@company.name} Interview Invitation")
  end


  def shortlist(interview, email)
    @interview = interview
    @company = interview.company
    @company_img = @company.image
    @interview_page = @company.subdomain
    @url = 'https://www.dropque.com'
    @app = 'https://bit.ly/dropqueapp'
    mail(to: email, subject: "#{@company.name} Notification: You are Shortlisted") 
  end


  def reject(interview, email)
    @interview = interview
    @company = interview.company
    @company_img = @company.image
    @interview_page = @company.subdomain
    @url = 'https://www.dropque.com'
    @app = 'https://bit.ly/dropqueapp'
    mail(to: email, subject: "#{@company.name} Notification")
  end
end
