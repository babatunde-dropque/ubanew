class Group < ActiveRecord::Base
	validates :name, presence: true
	belongs_to  :company
	has_many  :bulks
end
