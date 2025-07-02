class Department < ApplicationRecord

	validates :name, presence: true
	default_scope  { order(:name => :asc) }
end
