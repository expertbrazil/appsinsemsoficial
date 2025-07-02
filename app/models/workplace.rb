class Workplace < ApplicationRecord
	has_many :people_associateds

	validates :name, presence: true
	default_scope  { order(:name => :asc) }
end
