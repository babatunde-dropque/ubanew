# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
	
	def welcome_email
   		UserMailer.welcome_email(User.first)
  	end

  	def receive_notification
   		UserMailer.receive_notification(User.first, "you have been removed from Dropque international")
  	end
  	
end
