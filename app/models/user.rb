class User < ActiveRecord::Base
	
	has_many :notifications
	has_many :joint_user_companies
	has_many :companies, :through => :joint_user_companies
	# has_many :companies, :through => :joint_user_companies, :source => :companies

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
	  devise :invitable, :database_authenticatable, :registerable,
	         :recoverable, :rememberable, :trackable, :validatable

 # allow user to be able to comment
   acts_as_commontator

 # this will allow user to be able to rate
   ratyrate_rater
end
