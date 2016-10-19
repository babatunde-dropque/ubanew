class SendEmailJob < ActiveJob::Base
   queue_as :default

 	# jobs to help send email in the background for faster processing
  def perform(user)
  	# Do something later
    @user = user
    ExampleMailer.sample_email(@user).deliver_later
  end
end
