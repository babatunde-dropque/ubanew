require 'slack-notifier'
class User < ActiveRecord::Base
    # before_save :capitalize_first_character
    has_many :indentities
	has_many :notifications
	has_many :joint_user_companies
	has_many :companies, :through => :joint_user_companies
    has_many :submissions
    mount_uploader :a_dp, ADpUploader
    mount_uploader :a_cv, ACvUploader

     after_create  :send_slack_notification
     def send_welcome_mail
        InterviewMailer.welcome_email(self).deliver
     end

    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
	devise :invitable, :database_authenticatable, :registerable,
	       :recoverable, :rememberable, :trackable, :validatable, :omniauthable

    # allow user to be able to comment
    acts_as_commontator

   #this will allow user to be able to rate
   ratyrate_rater





   # def capitalize_first_character
   #    self.name.split.map(&:capitalize).join(' ')
   # end
   def self.search_category

   end





   def send_slack_notification
    if Rails.env.production?
        notifier = Slack::Notifier.new "https://hooks.slack.com/services/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", channel: '#notification', username: 'signup'
        notifier.ping "New Signup by " + self.name + " email: " + self.email
    end
   end

end
