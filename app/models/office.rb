class Office < ApplicationRecord
	validates :name, presence: true
	has_many :people_associateds

	default_scope  { order(:name => :asc) }
end
