CarrierWave.configure do |config|
	config.permissions = 0777
	config.directory_permissions = 0700
	config.storage = :file
	config.ignore_integrity_errors = false
	config.ignore_processing_errors = false
	config.ignore_download_errors = false
end