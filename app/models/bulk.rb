require 'roo'
class Bulk < ActiveRecord::Base
    attr_accessible :name, :email, :telephone


    def self.fetch(file)
       ex = Excel.new(file.path, nil, :ignore)
       ex.default_sheet = ex.sheets[1]
       3.upto(1000) do |line|
       name = ex.cell(line,’A’)
       email = ex.cell(line,’B’)
       telephone = ex.cell(line,’C’)
       @bulk = Bulk.create(:name => name,:email => email,:telephone => telephone)
      end
   end
  	def self.import(file)
        spreadsheet = open_spreadsheet(file)
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        bulk = find_by_id(row["id"]) || new
        bulk.attributes = row.to_hash.slice(*accessible_attributes)
        bulk.save!
      end
    end

     def self.open_spreadsheet(file)
      case File.extname(file.original_filename)
      when ".csv" then Roo::CSV.new(file.path)
      when ".xls" then Roo::Excel.new(file.path)
      when ".xml" then Roo::Excel2003XML.new(file.path)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else raise "Unknown file type: #{file.original_filename}"
      end
    end


end
