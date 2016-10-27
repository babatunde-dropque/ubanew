class InterviewMailer < ActionMailer::Base
	helper	:application
  default from: "invite@dropque.com"

  def interview_invite(interview, email)
  	@interview = interview
  	@company = interview.company
  	@url = 'https://www.dropque.com'
  	@app = 'https://bit.ly/dropqueapp'
  	mail(to: email, subject: "#{@company.company_name} Interview Invitation")
  end

  def shortlist(interview, email)
  	@interview = interview
  	@company = interview.company
  	@url = 'https://www.dropque.com'
  	@app = 'https://bit.ly/dropqueapp'
  	mail(to: email, subject: "#{@company.company_name} Notification: You are Shortlisted")  	
  end

  def reject(interview, email)
  	@interview = interview
  	@company = interview.company
  	@url = 'https://www.dropque.com'
  	@app = 'https://bit.ly/dropqueapp'
  	mail(to: email, subject: "#{@company.company_name} Notification")
  end
end
