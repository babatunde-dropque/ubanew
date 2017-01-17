class NotifierMailer < ApplicationMailer
	default from: "notification@dropque.com"

	def demo_request(name, email, organization, role, purpose)
	    @name = name
	    @email = email
	    @organization = organization
	    @role = role
	    @purpose = purpose
	   mail(to: "notificationgroup@dropque.com", subject: "New Demo Request")
	end


	def user_notification(user_object, company_name, message)
		# user_id, type, sender_id, company_name
		@name = user_object.name
		@message = message
		@company_name = company_name
    	mail(to: user_object.email , subject: "Dropque Notification")
	end
end
