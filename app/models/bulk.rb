class Bulk < ActiveRecord::Base

	def self.import(file)
		CSV.foreach(file.path, headers: true) do |row|
		Bulk.create! row.to_hash
		end
	end
end
