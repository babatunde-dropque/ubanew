class ReminderMailer < ApplicationMailer

      def  reminder(email, interview)
      	@email = email
      	@interview = interview
      	@interview_title = @interview.title
      	@company = interview.company
      	@company_email = @company.email
      	@token = @interview.interview_token
      	@interview_page = "https://#{@company.subdomain}.dropque.com/applicants/#{@token}"
      	@company_img = @company.logo
      	mail(from:"reminder@dropque.com", to: email, subject: "#{@interview.title} Interview Reminder")
      end

end
