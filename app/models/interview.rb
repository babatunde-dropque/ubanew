class Interview < ActiveRecord::Base
	include FriendlyId
	
	belongs_to :company
	has_many :submissions
	has_many :users, :through => :submissions
	before_create :tokenize

	 friendly_id :title, :use => :slugged 

    def should_generate_new_friendly_id?
    	 slug.nil? || title_changed? || new_record?
 	end

    # Try building a slug based on the following fields in
  	# increasing order of specificity.
    def slug_candidates
	    [
	      :title,
	      [:title, :created_at]
	    ]
  	end


  protected
  
  def tokenize
  	self.interview_token = SecureRandom.hex(3)
  end

end
