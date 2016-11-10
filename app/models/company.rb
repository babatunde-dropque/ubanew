class Company < ActiveRecord::Base
	include FriendlyId
	
	 has_many :joint_user_companies 
   has_many :users, :through => :joint_user_companies
   has_many :interviews
   has_many :contacts, dependent: :destroy 
   has_many :groups, dependent: :destroy 
	 has_many :submissions, :through => :interviews, dependent: :destroy

    mount_uploader :image, ImageUploader
    mount_uploader :logo, LogoUploader

     # find out what dependent destroy means before usin it
     # has_many :users, :through=> :joint_user_companies, dependent: :destroy 


    friendly_id :name, :use => :slugged 

    def should_generate_new_friendly_id?
    	 slug.nil? || name_changed? || new_record?
 	  end

    # Try building a slug based on the following fields in
  	# increasing order of specificity.
    def slug_candidates
    [
      :name,
      [:name, :subdomain]
    ]
  end
     
end
