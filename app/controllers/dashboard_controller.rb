class DashboardController < ApplicationController
	before_action :authenticate_user!, except: [:twilio, :twilio_message]
	skip_before_action :verify_authenticity_token, only: [:twilio, :twilio_message]

	def index
		@dependents_benefit_expired = if current_user.professional.nil?
										Dependent.includes(:people_associated).joins(:people_associated).where('dependents.benefit_until <= ?', Date.current + 5.days).order(benefit_until: :asc).page(params[:page])
									else
										[]
									end
		@people_associated_in_analysis = PeopleAssociated.in_analysis
	end

	def twilio
		respond_to do |format|
			format.any { render status: 200, layout: false, json: params.to_json }
		end
	end


	def twilio_message
		@body = params["Body"]
		# @sid = params["MessageSid"]
		@status = params["SmsStatus"] 
		@send_return_message = false

		
		@from = params["From"]
		if !@from.blank?
			@from_n = @from.split(":")[1]
     	  @phone = @from_n.tap {|s| s.slice!(0..2) }.insert(2, '9').insert(0, '(').insert(3, ')').insert(4, ' ').insert(6, ' ').insert(11, '-')  		
		end	
		
		if @status == "received"

			# 1 confirma associado, 2 cancela associado	 
			if @body.to_i == 1 || @body.to_i == 2
				@people_associated = PeopleAssociated.find_by_cell_phone(@phone)			
				@appointmentPeople = AppointbookPeopleassoci.where('start_datetime >= ? AND start_datetime < ? AND people_associated_id = ?', (Time.now + 2.day).beginning_of_day, (Time.now + 2.day).end_of_day, @people_associated.id).first if @people_associated.present?

			# 3 confirma dependente, 4 cancela dependente
			elsif @body.to_i == 3 || @body.to_i == 4			
				@dependent = Dependent.find_by_cell_phone(@phone)
				@appointmentPeople = AppointbookPeopleassoci.where('start_datetime >= ? AND start_datetime < ? AND dependent_id = ?', (Time.now + 2.day).beginning_of_day, (Time.now + 2.day).end_of_day, @dependent.id).first if @dependent.present?				
			end

			# @appointmentPeople = AppointbookPeopleassoci.where('start_datetime >= ? AND start_datetime < ? AND sid = ?', (Time.now + 2.day).beginning_of_day, (Time.now + 2.day).end_of_day, @sid).first unless @sid.blank?
			
			# confirmar
			if @appointmentPeople.present? && @appointmentPeople.confirmed.nil? && (@body.to_i == 1 || @body.to_i == 3)
				@appointmentPeople.confirm!("Confirmado via Wathsapp! Dia #{Time.now.strftime('%d/%m/%Y')} às #{Time.now.strftime('%H:%M')}")
				@send_return_message = true
			end
			
			# cancelar				
			if @appointmentPeople.present? && (@appointmentPeople.confirmed.nil? || @appointmentPeople.confirmed) && (@body.to_i == 2 || @body.to_i == 4)
				@appointmentPeople.cancel!("Cancelado via Wathsapp! Dia #{Time.now.strftime('%d/%m/%Y')} às #{Time.now.strftime('%H:%M')}") 
				@send_return_message = true					
			end
			logger.debug "====="
			logger.debug @send_return_message
		end		

		respond_to do |format|
			format.xml { render status: 200, layout: false }
		end
	end

	def sms
		body = helpers.parse_sms(params)
	    
	    response = Twilio::TwiML::MessagingResponse.new do |r|
	      r.message body: body
	    end

	    render xml: response.to_s
	end
end
