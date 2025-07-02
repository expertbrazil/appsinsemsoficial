class TwilioController < ApplicationController
  skip_before_action :verify_authenticity_token

  def sms
    # body = helpers.parse_sms(params)
    response = Twilio::TwiML::MessagingResponse.new do |r|
      r.message body: "The Robots are coming! Head for the hills"
    end
    render xml: response.to_s
  end

  def confirma
  	@token_present = params[:token].present?
  	@appointmentPeople = AppointbookPeopleassoci.where(token: params[:token]).first if @token_present

	@appointmentPeople.confirm!("Confirmado via SMS! Dia #{Time.now.strftime('%d/%m/%Y')} às #{Time.now.strftime('%H:%M')}") if @appointmentPeople.present? && @appointmentPeople.confirmed.nil?
	
	respond_to do |format|
		if @token_present
			format.html { render  status: 200, layout: false }
		else
			format.html { render status: 404, layout: false }
		end
	end
  end
end