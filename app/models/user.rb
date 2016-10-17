class User < ActiveRecord::Base
	
	has_many :notifications
	has_many :joint_user_companies
	has_many :companies, :through => :joint_user_companies
	# has_many :companies, :through => :joint_user_companies, :source => :companies

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
	  devise :invitable, :database_authenticatable, :registerable,
	         :recoverable, :rememberable, :trackable, :validatable
end
