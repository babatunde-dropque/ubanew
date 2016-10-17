class Interview < ActiveRecord::Base
	
	belongs_to :company
	has_many :submissions
	has_many :users, :through => :submissions
	before_create :tokenize

  protected
  def tokenize
  	self.job_token = SecureRandom.hex(3)
  end

end
