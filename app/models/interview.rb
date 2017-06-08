class Interview < ActiveRecord::Base
	include FriendlyId
   require 'rubygems'
   require 'twilio-ruby'
  # require 'sinatra'

	belongs_to :company
	has_many :submissions
	has_many :users, :through => :submissions
	before_create :tokenize

	 friendly_id :title, :use => :slugged

    def should_generate_new_friendly_id?
    	 slug.nil? || title_changed? || new_record?
 	  end

    # inbuilt search query added by Ibukun
    def self.search(search)
      where("lower(title) LIKE ?", "%#{search.downcase}%")
      # where("description LIKE ?", "%#{search}%")
    end

    def self.sms_reminder(company, interview, telephone, title)
        account_sid = ENV["TWILLIO_ACCOUNT_SID"]
        auth_token = ENV["TWILLIO_AUTH_TOKEN"]
        client = Twilio::REST::Client.new account_sid, auth_token
        from = "+18583815995" # Your Twilio number
        @interview = interview
        @interview_title = @interview.title
        @company = company
        #@company = @interview.company
        @company_email = @company.email
        @token = @interview.interview_token
        @interview_page = "https://#{@company.subdomain}.dropque.com/applicants/#{@token}"
        client.account.messages.create(
        :from => from,
        :to => telephone,
        :body => "Hello #{title}, your response to "+@interview.title+" interview of "+@company.slug.capitalize+" is incomplete.   Please click "+@interview_page+" to complete your interview!"
        )
    end

    def self.fetch_line_data(interview)

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


  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |submission|
        csv << submission.attributes.values_at(*column_names)
      end
    end
  end

end
