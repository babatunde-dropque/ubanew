require 'slack-notifier'
class LandingsController < ApplicationController

	layout 'landing'


  def index
    if user_signed_in? && current_user.status == 1
	    self.dashboard_function()
    elsif user_signed_in? && current_user.status == 0
        redirect_to user_timeline_path(current_user)
    elsif user_signed_in? && current_user.status == nil
        redirect_to user_profile_path(current_user)
	end
	@minimum_password_length = 6
  end


  def newhome

  end

  def pricing
  end

  def contact

  end

  def request_demo
    demo = RequestDemo.new(create_request_params)
    if demo.save

      # send to our slack channel
      if Rails.env.production?
        notifier = Slack::Notifier.new "https://hooks.slack.com/services/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", channel: '#notification', username: 'requestDemo'
        notifier.ping "New Request Demo by " + params[:name] + "\n" +
                      "email: " + params[:email] + "\n" +
                      params[:role] + "\n" +
                      "with number(" + params[:telephone] + ")\n" +
                      "at organization(" + params[:organization] + ")\n" +
                      "want to use dropque for " + params[:purpose] + "\n" +
                      "One of us should kindly reach out. Thanks Dropque Bot"
      end

      # send to our notificationgroup@dropque.com general mail
      # parameter is as follows, name, email, organization, role, purpose
      NotifierMailer.demo_request(params[:name], params[:email], params[:organization],params[:role], params[:purpose], params[:telephone]).deliver

      render text: "true"
    else

      render text: "false"
    end
  end

  def errors
  	 render status_code.to_s, :status => status_code, :layout => 'signin'
  end

  

protected
 
  def status_code
    params[:code] || 500
  end

private

def create_request_params
    params.permit(:name, :telephone, :email, :organization, :role, :purpose, :additional_message)
end

end
