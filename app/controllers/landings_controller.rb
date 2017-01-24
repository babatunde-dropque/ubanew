require 'slack-notifier'
class LandingsController < ApplicationController
	layout 'landing'
	
  def index
		if user_signed_in?
			redirect_to user_dashboard_path(current_user)
		end 
		@minimum_password_length = 6
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
                      "at organization(" + params[:organization] + ")\n" +
                      "want to use dropque for " + params[:purpose] + "\n" +
                      "One of us should kindly reach out. Thanks Dropque Bot"
      end 

      # send to our notificationgroup@dropque.com general mail
      # parameter is as follows, name, email, organization, role, purpose
      NotifierMailer.demo_request(params[:name], params[:email], params[:organization],params[:role], params[:purpose]).deliver

      render text: "true"
    else

      render text: "false"
    end
  end

  def errors
  	 render status_code.to_s, :status => status_code, :layout => 'signin'
  end

  def letsencrypt
    # use your code here, not mine
    render text: "JJb5NafWAfbIbsyeUhvCzd4NQGgEZK9Mz0izsS9A9UY.CriSZxM1w6GS2r0o8SJiBR7VSo94RaaZqvdmZgVH7eI"
  end
 

protected
 
  def status_code
    params[:code] || 500
  end

private

def create_request_params
    params.permit(:name, :email, :organization, :role, :purpose, :additional_message)
end

end
