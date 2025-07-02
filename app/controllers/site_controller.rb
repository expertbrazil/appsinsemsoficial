class SiteController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout 'site'
	
	def inscription
		if request.get?
			@people_associated = PeopleAssociated.new
    		@people_associated.number_registration = PeopleAssociated.next_number_registration    
    	elsif request.post?
    		@people_associated = PeopleAssociated.new(people_associated_params)
        @people_associated.in_analysis = true
        @people_associated.situation = 0
    		@people_associated.public_form = true
    		
    		respond_to do |format|
	    		if @people_associated.save
	        		format.html { redirect_to site_welcome_path(token: @people_associated.token), notice: "Inscrição enviada para análise." }
	      		else
	        		format.html { render :inscription }
	      		end
      		end
    	end
	end

  def welcome
	@people_associated = PeopleAssociated.find_by_token(params[:token]) if params[:token].present? && !params[:token].blank?

	respond_to do |format|
		format.html
		format.pdf do
        	render pdf: "autorizacao_#{DateTime.current}",
        	margin: {
          	top: 5,
          	bottom: 30
        	}
      	end
    end
    # render layout: false
  end


  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def people_associated_params
      params.require(:people_associated).permit(:term_of_consent, :blood_type, :is_allergic, :take_controlled_medicine, :take_controlled_medicine_description, :username, :password, :password_confirmation, :number_registration, :name, :birthdate, :gender, :email, :phone, :address, :number, :complement, :zipcode, :burgh, :city, :state, :cpf, :rg, :marital_status, :place_birth, :scholarity, :profession, :photo, :situation, :mother, :father, :breed, :title_voter, :zone_voter, :section_voter, :workplace_id, :admission_date, :bond, :validity_card, :partner, :dispatcher_organ, :father_mother, :created_at, :start_registration, :office_id, :occupation_id, :spouse, :parading_date, :department_id, :observation, :cell_phone1, :cell_phone2, :affiliate_date, :hollering_registration, :gross_salary, system_attachments_attributes: [:id, :name, :archive, :_destroy], dependents_attributes: [:id, :institution_name, :name, :birthdate, :degree_of_kinship, :other_manual, :validate_statement, :with_special_needs, :active, :benefit_until, :cpf, :rg, :dispatcher_organ, :is_student, :phone, :cell_phone, :username, :password, :password_confirmation, :_destroy, system_attachments_attributes: [:id, :name, :archive, :_destroy]])
    end
end