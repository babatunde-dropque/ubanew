class User < ActiveRecord::Base
    has_many :oauth_accounts
	has_many :notifications
	has_many :joint_user_companies
	has_many :companies, :through => :joint_user_companies
    has_many :submissions
    mount_uploader :a_dp, ADpUploader
    mount_uploader :a_cv, ACvUploader

     after_create :send_welcome_mail
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
end
