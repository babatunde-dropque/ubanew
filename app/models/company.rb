class Company < ActiveRecord::Base
	# include FriendlyId
	
	 has_many :joint_user_companies 
     has_many :users, :through => :joint_user_companies

     # find out what dependent destroy means before usin it
     # has_many :users, :through=> :joint_user_companies, dependent: :destroy 
     
end
