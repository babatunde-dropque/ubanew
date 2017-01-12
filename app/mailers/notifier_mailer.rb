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
end
