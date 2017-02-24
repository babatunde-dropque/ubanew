class User < ActiveRecord::Base

	has_many :notifications
	has_many :joint_user_companies
	has_many :companies, :through => :joint_user_companies
	# has_many :companies, :through => :joint_user_companies, :source => :companies
    # def send_welcome_mail
    # 	tola = User.last
    # 	UserMailer.welcome_email(tola).deliver
    # end
     after_create :send_welcome_mail
     def send_welcome_mail
     #InterviewMailer.welcome_email(self).deliver
     end

    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
	devise :invitable, :database_authenticatable, :registerable,
	         :recoverable, :rememberable, :trackable, :validatable

    # allow user to be able to comment
    acts_as_commontator

   #this will allow user to be able to rate
   ratyrate_rater
end
