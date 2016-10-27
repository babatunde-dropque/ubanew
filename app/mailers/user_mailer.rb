class UserMailer < ApplicationMailer
   default from: 'notifications@dropque.com'
   # layout 'awesome' # use awesome.(html|text).erb as the layout
 
  def welcome_email(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user.email , subject: 'Welcome to My Awesome Site')
  end


  def receive_notification(user, message )
  	@user = user
  	@message = message
  	mail(to: @user.email, subject: 'New notification')
  end 

end
