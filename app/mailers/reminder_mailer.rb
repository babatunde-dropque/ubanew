class ReminderMailer < ApplicationMailer

      def  reminder(email, name, interview)
      	@email = email
            @name = name
      	@interview = interview
      	@interview_title = @interview.title
            @interview_deadline = @interview.deadline
      	@company = interview.company
      	@company_email = @company.email
      	@token = @interview.interview_token
      	@interview_page = "https://#{@company.subdomain}.dropque.com/applicants/#{@token}"
      	@company_img = @company.logo
      	mail(from:"reminder@dropque.com", to: email, subject: "#{@interview.title} at #{@company.name} Notification")
      end

end
