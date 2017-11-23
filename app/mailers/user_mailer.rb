class UserMailer < ApplicationMailer
   default from: 'Dropque'
   # layout 'awesome' # use awesome.(html|text).erb as the layout

  # def welcome_email(user)
  #   @user = user
  #   @name = @user.name
  #   @dashboard  = 'http://www.dropque.com/dashboard'
  #   @dropque = "Dropque Inc"
  #   mail( to: @user.email , subject: 'Welcome to Dropque')
  # end


  def receive_notification(user, message )
  	@user = user
  	@message = message
  	mail(to: @user.email, subject: 'New notification')
  end

end
