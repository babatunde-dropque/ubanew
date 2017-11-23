class FileUpload < ActiveRecord::Base
	 mount_uploader :file_link, FileUploader
end
