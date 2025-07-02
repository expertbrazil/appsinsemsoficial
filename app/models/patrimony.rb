class Patrimony < ApplicationRecord
 	validates :name, :patrimony_number, presence: true
  	validates :patrimony_number, uniqueness: true
  	validates :year_car, :numericality => {:only_integer => true}, :if => lambda { |object| object.year_car.present? }

	default_scope  { order(:name => :asc) }

  	belongs_to :supplier
  	belongs_to :room
  	belongs_to :type_incorporation
  	belongs_to :heritage_group
  	belongs_to :effort

  	filterrific(
	    available_filters: [
	      :sorted_by,
	      :search_query,       
	      :with_active_flag
	    ]
  	)

  	scope :with_active_flag, lambda { |flag|
  		where(active: [*flag])
  	}  

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
	          "LOWER(patrimonies.name) LIKE ?"         	          
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
	      		order("patrimonies.created_at #{ direction }")
	    	when /^name_/
	      		order("LOWER(patrimonies.name) #{ direction }")
			when /^date_of_acquisition/
	      		order("patrimonies.date_of_acquisition #{ direction }")
	    	else
	      		raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    	end
  	}
	
	def self.options_for_sorted_by
    	[
      		['Nome (a-z)', 'name_asc'],
      		['Data de cadastro (recentes primeiro)', 'created_at_desc'],
      		['Data de cadastro (antigos primeiro)', 'created_at_asc'],
      		['Data de aquisição (recentes primeiro)', 'date_of_acquisition_desc'],
      		['Data de aquisição (antigos primeiro)', 'date_of_acquisition_asc'] 
    	]
  	end

  	def type_incorporation_describe?
  		type_incorporation.present? && type_incorporation.to_describe
  	end  	

  	def effort_describe?
  		effort.present? && effort.to_describe
  	end
end
