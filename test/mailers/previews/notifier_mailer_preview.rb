# Preview all emails at http://localhost:3000/rails/mailers/notifier_mailer
class NotifierMailerPreview < ActionMailer::Preview
 
 # http://localhost:3000/rails/mailers/notifier_mailer/demo_request
  def demo_request
    NotifierMailer.demo_request("muyide ibukun", "superibk@gmail.com", "IOM","Software Engineer", "Used for recruiting")
  end

end
