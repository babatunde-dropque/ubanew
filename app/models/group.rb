class Group < ActiveRecord::Base
	include FriendlyId

	validates :name, presence: true
	belongs_to  :company
	has_many  :bulks, dependent: :destroy


	friendly_id :name, :use => :slugged 

    def should_generate_new_friendly_id?
    	 slug.nil? || name_changed? || new_record?
 	  end

    # Try building a slug based on the following fields in
  	# increasing order of specificity.
    def slug_candidates
    [
      :name,
      [:name, :auto_response]
    ]
  end
end
