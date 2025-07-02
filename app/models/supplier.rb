class Supplier < ApplicationRecord
	has_many :patrimonies
	has_address :address
	
	default_scope  { order(:name => :asc) }

	
	validates :cpf, presence: true, :if => :fisica?
	# validates :cnpj, presence: true, :unless => :fisica?

	TYPES = [['Física', 1], ['Jurídica', 2]]

	def type_name
		fisica? ? 'Física' : 'Jurídica'
	end


	def fisica?
		entity_type == 1
	end

	def self.options_for_select
    	order('LOWER(razao_social) ASC, LOWER(name) ASC').map { |e| [e.name.upcase, e.id] }
  	end


  ############ FILTROS ############
	filterrific(
		:available_filters => [
			 	:sorted_by,
      	:search_query
    	]
  	)

  	scope :search_query, lambda { |query|
		return nil  if query.blank?
	    # condition query, parse into individual keywords
	    terms = query.to_s.downcase.split(/\s+/)
	    # replace "*" with "%" for wildcard searches,
	    # append '%', remove duplicate '%'s
	    terms = terms.map { |e|
	      ('%' + e.gsub('*', '%') + '%').gsub(/%+/, '%')
	    }
	    # configure number of OR conditions for provision
	    # of interpolation arguments. Adjust this if you
	    # change the number of OR conditions.
	    num_or_conditions = 2
	    where(
	      terms.map {
	        or_clauses = [
	          "LOWER(razao_social) LIKE ?", "LOWER(name) LIKE ?"
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
          order("suppliers.created_at #{ direction }")
      when /^name_/
          order("LOWER(suppliers.name) #{ direction }, LOWER(suppliers.razao_social) #{ direction }")       
      else
          raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }
	
	def number_doc
		self.cpf || self.cnpj
	end
	
end
