# Preview all emails at http://localhost:3000/rails/mailers/reminder_mailer
class ReminderMailerPreview < ActionMailer::Preview

	 # Preview this email at http://localhost:3000/rails/mailers/reminder_mailer/reminder
	def  reminder
      	ReminderMailer.reminder("superibk@gmail.com", "Muyide Ibukun", Interview.last)
    end

end
