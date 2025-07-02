class SystemAttachment < ApplicationRecord
	mount_base64_uploader :archive, SystemAttachmentUploader

	belongs_to :people_associated, optional: true
	belongs_to :dependent, optional: true
	belongs_to :bills_pay, optional: true
	belongs_to :bills_receife, optional: true

end
