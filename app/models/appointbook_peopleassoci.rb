# require 'twilio-ruby'
require 'comtele_sdk';
include ComteleSdk
#encoding: utf-8

class AppointbookPeopleassoci < ApplicationRecord
  before_validation :set_token, on: :create

  belongs_to :appointment_book
  belongs_to :people_associated
  belongs_to :dependent

  attr_accessor :people_id, :people_type
  validates :start_datetime, presence: true
  validates :people_id, presence: true, on: :create
  
  before_save :set_end_datetime
  before_create :set_id_by_type

  	def to_jq_upload(opts={})
      {
        "id" => id,
        "professional_id" => appointment_book.professional.id,
        "title" => ( opts[:is_patient] ? ' Reservado' : (people_associated ? "#{people_associated.name}" : (dependent ? "#{dependent.name}" : ''))),
        "situation" => situation,
        "status" => status,
        "start" => start_datetime || Date.current,
        "end" => end_datetime || Date.current,
        "allDay" => false,
        "color" => render_color
      }
  	end

    def status
      if start_attendance && !stop_attendance
        "Em Atendimento"
      elsif start_attendance && stop_attendance
        "Atendimento Finalizado"
      elsif confirmed && !showed
        "Confirmado"
      elsif canceled?
        "Cancelado"          
      elsif showed
        "Compareceu"
      elsif confirmed.nil?
        ""
      else !confirmed
        ""
      end
    end

    def render_color
      if start_attendance && !stop_attendance
        "#00BCD4"
      elsif start_attendance && stop_attendance
        "#FF9800"
      elsif confirmed && !showed
        "#2196F3"
      elsif canceled?
        "#F44336"          
      elsif showed
        "#4CAF50"
      elsif confirmed.nil?
        "#13057f"
      else !confirmed
        "#d9534f"
      end
    end

 

    def unconfirmed?
      confirmed.nil?
    end


    def unshowed?
      !showed
    end

    def canceled?
      canceled
    end


    def confirm!(observation='')
      self.confirmed = true
      self.observation = observation
      save!
    end


    def attend!
      self.showed = true
      save!
    end    

    def attendance_start!
      self.start_attendance = true
      save!
    end

    def attendance_stop!
      self.stop_attendance = true
      save!
    end

    def cancel!(observation)
      # self.confirmed = false
      self.canceled = true
      self.observation = observation
      save!
    end


    filterrific(
      available_filters: [
        :sorted_by,
        :with_professional_id,
        :search_people,
        :start_datetime_gte,
        :start_datetime_lt,
        :with_type_function_id
      ]
    )

    scope :with_professional_id, lambda { |profissional_ids|
     where(["professionals.id = ?", *profissional_ids])
    }   

    scope :with_type_function_id, lambda { |type_function_ids|
     where(["professionals.type_function = ?", *type_function_ids])
    }  

    scope :search_people, lambda { |query|
      return nil  if query.blank?
        # condition query, parse into individual keywords
        terms = query.downcase.split(/\s+/)
        # replace "*" with "%" for wildcard searches,
        # append '%', remove duplicate '%'s
        terms = terms.map { |e|
          ('%'+ e.gsub('*', '%') + '%').gsub(/%+/, '%')
        }
        # configure number of OR conditions for provision
        # of interpolation arguments. Adjust this if you
        # change the number of OR conditions.
        num_or_conditions = 2
        where(
          terms.map {
            or_clauses = [
              "LOWER(people_associateds.name) LIKE ?" ,        
              "LOWER(dependents.name) LIKE ?"         
            ].join(' OR ')
            "(#{ or_clauses })"
          }.join(' AND '),
          *terms.map { |e| [e] * num_or_conditions }.flatten
        )
    }

  scope :start_datetime_gte, lambda { |reference_time|
    where('appointbook_peopleassocis.start_datetime >= ?', Time.zone.parse(reference_time))
  }

  scope :start_datetime_lt, lambda { |reference_time|
    where('appointbook_peopleassocis.start_datetime < ?', Time.zone.parse(reference_time))
  }
 
  scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
      when /^created_at_/
          order("appointbook_peopleassocis.created_at #{ direction }")
      when /^name_/
          order("LOWER(people_associateds.name) #{ direction }, LOWER(dependents.name) #{ direction }")
      when /^start_datetime_/
          order("LOWER(appointbook_peopleassocis.start_datetime) #{ direction }")
      else
          raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  def self.options_for_sorted_by
    [
        #['Nome (a-z)', 'name_asc'],
        #['Data de cadastro (recentes primeiro)', 'created_at_desc'],
        #['Data de cadastro (antigos primeiro)', 'created_at_asc'],
        ['Data de atedimento (recentes primeiro)', 'start_datetime_desc'],
        ['Data de atedimento (antigos primeiro)', 'start_datetime_asc'],
    ]
  end



  def self.comtele_sms
    @api_key = '5c693d48-e205-4d9c-aef8-c325845902c4'
    @textmessage_service = TextMessageService.new(@api_key) #ContextMessageService
   
    AppointbookPeopleassoci.where('start_datetime >= ? AND start_datetime < ? AND confirmed IS NULL AND showed IS false', (Time.now + 1.day).beginning_of_day, (Time.now + 1.day).end_of_day).each do |appointment_book_people|
      whatsapp_number = appointment_book_people.people_associated.present? ? appointment_book_people.people_associated.cell_phone_send_to_wahtsapp : (appointment_book_people.dependent.present? ? appointment_book_people.dependent.cell_phone_send_to_wahtsapp : '')
      if !whatsapp_number.blank? 
        body = "Olá, #{appointment_book_people.people_associated.present? ? appointment_book_people.people_associated.first_and_last_name : appointment_book_people.dependent.present? ? appointment_book_people.dependent.first_and_last_name : ''}! 
Você possui uma consulta com a #{appointment_book_people.appointment_book.professional.function_name} dia #{appointment_book_people.start_datetime.strftime('%d/%m')} às #{appointment_book_people.start_datetime.strftime('%H:%M')},
Responda #{appointment_book_people.people_associated.present? ? '1 para confirmar sua presença ou 2 para cancelar' : appointment_book_people.dependent.present? ? '3 para confirmar sua presença ou 4 para cancelar' : ''}
SINSEMS"

        @textmessage_service.send('66996237029', body, [whatsapp_number]);
        sleep 3
      end
    end
  end

  def self.twilio_whatsapp_notificate
    # put your own credentials here
    # live sinsems
    # account_sid = '***REMOVED***' # [CREDENCIAL SENSÍVEL COMENTADA]
    # auth_token = '***REMOVED***'    # [CREDENCIAL SENSÍVEL COMENTADA]

     #test sinsems
    # account_sid = '***REMOVED***' # [CREDENCIAL SENSÍVEL COMENTADA]
    # auth_token = '***REMOVED***'    # [CREDENCIAL SENSÍVEL COMENTADA]

    # # curtarelli79
    # account_sid = '***REMOVED***' # [CREDENCIAL SENSÍVEL COMENTADA]
    # auth_token = '152c990a00bacbc257da4d54d241f160'    # [CREDENCIAL SENSÍVEL COMENTADA]

    # set up a client to talk to the Twilio REST API
    # @client = Twilio::REST::Client.new(account_sid, auth_token)

    AppointbookPeopleassoci.where('start_datetime >= ? AND start_datetime < ? AND confirmed IS NULL AND showed IS false', (Time.now + 1.day).beginning_of_day, (Time.now + 1.day).end_of_day).each do |appointment_book_people|
      whatsapp_number = appointment_book_people.people_associated.present? ? appointment_book_people.people_associated.cell_phone_send_to_wahtsapp : (appointment_book_people.dependent.present? ? appointment_book_people.dependent.cell_phone_send_to_wahtsapp : '')
      if !whatsapp_number.blank? 
  #       message = @client.messages.create(
  #                              from: 'whatsapp:+19083452048',
  #                              body: "Olá, #{appointment_book_people.people_associated.present? ? appointment_book_people.people_associated.name : appointment_book_people.dependent.present? ? appointment_book_people.dependent.name : ''}!

  # Você possui uma consulta com a #{appointment_book_people.appointment_book.professional.function_name} amanhã, #{appointment_book_people.start_datetime.strftime('%d/%m')} às #{appointment_book_people.start_datetime.strftime('%H:%M')}.

  # Responda #{appointment_book_people.people_associated.present? ? '1 para confirmar sua presença ou 2 para cancelar' : appointment_book_people.dependent.present? ? '3 para confirmar sua presença ou 4 para cancelar' : ''}.

  # Obrigado.

  # SINSEMS - Sindicato dos Servidores Públicos Municipais de Sorriso - MT!",
  #                              to: "whatsapp:+55#{whatsapp_number}"
  #                            )  
  # com confirmacao
#           body = "Olá, #{appointment_book_people.people_associated.present? ? appointment_book_people.people_associated.name : appointment_book_people.dependent.present? ? appointment_book_people.dependent.name : ''}! 
# para confirmar sua consulta com a #{appointment_book_people.appointment_book.professional.function_name} dia #{appointment_book_people.start_datetime.strftime('%d/%m')} às #{appointment_book_people.start_datetime.strftime('%H:%M')},
# Responda SIM"

      # if !appointment_book_people.token.blank?
      #   url_api = 'R_d49c2a9c37b24ddc8b49ccfe43c1f637'
      #   username = 'joelrupix'       

      #   bitly = Bitly.new(username, url_api)
      #   url = bitly.shorten("#{APP_CONFIG['site']['url']}sms/confirma/#{appointment_book_people.token}")
      # end

        body = "Olá, #{appointment_book_people.people_associated.present? ? appointment_book_people.people_associated.name : appointment_book_people.dependent.present? ? appointment_book_people.dependent.name : ''}! 
Você tem um compromisso com a #{appointment_book_people.appointment_book.professional.function_name} dia #{appointment_book_people.start_datetime.strftime('%d/%m')} às #{appointment_book_people.start_datetime.strftime('%H:%M')}
#{url.present? ? 'Para confirmar clique no link: ' + url.short_url : ''} 
SINSEMS
"
                               
        # message = @client.messages.create(
        #   from: '+12055513172', #'+19083452048',
        #   to: "+55#{whatsapp_number}",
        #   body: body
        # )
        

        p "======>> #{body.mb_chars.length}"
        
        sleep 3
      end
    end
  end

  private
    def set_end_datetime
      self.end_datetime = self.start_datetime + 10.minutes
    end

    def set_id_by_type
      if people_type == "people_associated"
        self.people_associated_id = self.people_id
      else
        self.dependent_id = self.people_id
      end
    end

    def set_token
      self.token = SecureRandom.uuid
    end
end
