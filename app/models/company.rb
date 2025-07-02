class Company < ApplicationRecord

	validates :name, presence: true

	belongs_to :segment

	filterrific(
	    available_filters: [
	      :sorted_by,
	      :search_query,         
	      :search_city,         
	      :search_state,         
	      :with_segment_ids,
	    ]
  	)

  	scope :with_segment_ids, lambda { |segment_ids|
  		where(segment: [*segment_ids])
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
	    num_or_conditions = 2
	    where(
	      terms.map {
	        or_clauses = [
	          "LOWER(companies.name) LIKE ?" ,        
	          "LOWER(companies.email) LIKE ?"         
	        ].join(' OR ')
	        "(#{ or_clauses })"
	      }.join(' AND '),
	      *terms.map { |e| [e] * num_or_conditions }.flatten
	    )
	}

	scope :search_city, lambda { |query|
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
	          "LOWER(companies.city) LIKE ?"         
	        ].join(' OR ')
	        "(#{ or_clauses })"
	      }.join(' AND '),
	      *terms.map { |e| [e] * num_or_conditions }.flatten
	    )
	}

	scope :search_state, lambda { |query|
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
	          "LOWER(companies.state) LIKE ?"         
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
	      		order("companies.created_at #{ direction }")
	    	when /^name_/
	      		order("LOWER(companies.name) #{ direction }")
	    	when /^agreement_at_/
	      		order("LOWER(companies.agreement_at) #{ direction }")
	    	else
	      		raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    	end
  	}

	def self.options_for_sorted_by
    	[
      		['Nome (a-z)', 'name_asc'],
      		['Data de cadastro (recentes primeiro)', 'created_at_desc'],
      		['Data de cadastro (antigos primeiro)', 'created_at_asc'],
      		['Data de contrato (recentes primeiro)', 'agreement_at_desc'],
      		['Data de contrato (antigos primeiro)', 'agreement_at_asc'],
    	]
  	end

    def self.add_by_xls
     file_path = Rails.root.join('convenios_empresas.xls')     
     spreadsheet = Roo::Excel.new(file_path, packed: false, file_warning: :ignore)
     header = spreadsheet.row(1)
      
      (2..spreadsheet.last_row).each do |i|
      	row = Hash[[header, spreadsheet.row(i)].transpose]
         if ( !row["Nome"].blank? )
          company = new
          @numero = !row["Endereco"].blank? ? row["Endereco"].split(',')[1] : 0
          company.attributes = {
            name: row["Nome"], 
            address: row["Endereco"], 
            number: @numero,
            phone: !row["Telefone"].blank? ? row["Telefone"].split('\n')[0] : '',
            benefit: row["Beneficio"]
          }
          company.save!(validate: false)
        end
      end
    end
end
