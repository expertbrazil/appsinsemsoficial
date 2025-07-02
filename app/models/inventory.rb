class Inventory < ApplicationRecord
	validates :description, presence: true
	has_many :inventory_movements

	UNIT = %w(KG UN PÇ)


	filterrific(
	    available_filters: [
	      :sorted_by,
	      :search_query
	    ]
  	)

  	scope :search_query, lambda { |query|
		return nil  if query.blank?
	    # condition query, parse into individual keywords
	    terms = query.downcase.split(/\s+/)
	    # replace "*" with "%" for wildcard searches,
	    # append '%', remove duplicate '%'s
	    terms = terms.map { |e|
	      (e.gsub('*', '%') + '%').gsub(/%+/, '%')
	    }
	    # configure number of OR conditions for provision
	    # of interpolation arguments. Adjust this if you
	    # change the number of OR conditions.
	    num_or_conditions = 1
	    where(
	      terms.map {
	        or_clauses = [
	          "LOWER(inventories.description) LIKE ?"
	        ].join(' OR ')
	        "(#{ or_clauses })"
	      }.join(' AND '),
	      *terms.map { |e| [e] * num_or_conditions }.flatten
	    )
	}

	scope :sorted_by, lambda { |sort_option|
    	# extract the sort direction from the param value.
    	direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    	case sort_option.to_s
	    	when /^created_at_/
	      		order("inventories.created_at #{ direction }")
	    	when /^name_/
	      		order("LOWER(inventories.description) #{ direction }")	    	
	    	else
	      		raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    	end
  	}

	def self.options_for_sorted_by
    	[
      		['Nome (a-z)', 'name_asc'],
      		['Data de cadastro (recentes primeiro)', 'created_at_desc'],
      		['Data de cadastro (antigos primeiro)', 'created_at_asc']
    	]
  	end
end
