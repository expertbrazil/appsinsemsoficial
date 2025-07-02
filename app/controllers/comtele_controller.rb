class ComteleController < ApplicationController
    skip_before_action :verify_authenticity_token
    layout false

  	def sms
		@body = params["ReceivedContent"]
		# @status = params["SmsStatus"] 
		@send_return_message = false

		
		@from = params["Sender"]
		if !@from.blank?
			# @from_n = @from.split(":")[1]
     	   @phone = @from.tap {|s| s.slice!(0..1) }.insert(0, '(').insert(3, ')').insert(4, ' ').insert(6, ' ').insert(11, '-')  		
		end	
		
		

		# 1 confirma associado, 2 cancela associado	 
		if @body.to_i == 1 || @body.to_i == 2
			@people_associated = PeopleAssociated.find_by_cell_phone(@phone)			
			@appointmentPeople = AppointbookPeopleassoci.where('start_datetime >= ? AND start_datetime < ? AND people_associated_id = ?', (Time.now + 1.day).beginning_of_day, (Time.now + 1.day).end_of_day, @people_associated.id).first if @people_associated.present?

		# 3 confirma dependente, 4 cancela dependente
		elsif @body.to_i == 3 || @body.to_i == 4			
			@dependent = Dependent.find_by_cell_phone(@phone)
			@appointmentPeople = AppointbookPeopleassoci.where('start_datetime >= ? AND start_datetime < ? AND dependent_id = ?', (Time.now + 1.day).beginning_of_day, (Time.now + 1.day).end_of_day, @dependent.id).first if @dependent.present?				
		end

		# @appointmentPeople = AppointbookPeopleassoci.where('start_datetime >= ? AND start_datetime < ? AND sid = ?', (Time.now + 2.day).beginning_of_day, (Time.now + 2.day).end_of_day, @sid).first unless @sid.blank?
		
		# confirmar
		if @appointmentPeople.present? && @appointmentPeople.confirmed.nil? && (@body.to_i == 1 || @body.to_i == 3)
			@appointmentPeople.confirm!("Confirmado via SMS! Dia #{Time.now.strftime('%d/%m/%Y')} às #{Time.now.strftime('%H:%M')}")
			@send_return_message = true
		end
		
		# cancelar				
		if @appointmentPeople.present? && (@appointmentPeople.confirmed.nil? || @appointmentPeople.confirmed) && (@body.to_i == 2 || @body.to_i == 4)
			@appointmentPeople.cancel!("Cancelado via SMS! Dia #{Time.now.strftime('%d/%m/%Y')} às #{Time.now.strftime('%H:%M')}") 
			@send_return_message = true					
		end

		logger.debug "====="
		@message = (@body.to_i == 1 || @body.to_i == 3) ? "Seu horário foi confirmado. Esperamos você!" : ((@body.to_i == 2 || @body.to_i == 4) ?  "Seu horário foi cancelado." : "Resposta inválida!")
		logger.debug @message
	 		
		respond_to do |format|
			format.json { render :json => {:message => @message } }
		end
  	end
end
