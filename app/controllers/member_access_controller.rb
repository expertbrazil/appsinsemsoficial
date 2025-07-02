class MemberAccessController < ApplicationController
	before_action :authenticate_people_associated!
	layout 'member'

	def index
		@appointment_books_people_associated = current_people_associated.appointbook_peopleassoci
                                            .order('appointbook_peopleassocis.start_datetime DESC')
                                            .page(params[:page]).per_page(12)	
	end

	def edit_profile
		@people_associated = current_people_associated
	end

  	def update_profile
  		if params[:people_associated][:password].blank?
      		params[:people_associated].delete(:password)
      		params[:people_associated].delete(:password_confirmation)
    	end


    	if current_people_associated.update(people_associated_params)
      		redirect_to '/area-associado', notice: 'Perfil atualizado com sucesso'
    	else
      		respond_to do |format|
      			format.html { render :edit_profile }     
      		end
    	end
  	end

private
  # Never trust parameters from the scary internet, only allow the white list through.
  def people_associated_params
    params.require(:people_associated).permit(:username, :password, :password_confirmation, :number_registration, :name, :birthdate, :gender, :email, :phone, :address, :number, :complement, :zipcode, :burgh, :city, :state, :cpf, :rg, :marital_status, :place_birth, :scholarity, :profession, :photo, :situation, :mother, :father, :breed, :title_voter, :zone_voter, :section_voter, :workplace_id, :admission_date, :bond, :validity_card, :partner, :dispatcher_organ, :father_mother, :created_at, :start_registration, :office_id, :occupation_id, :spouse, :parading_date, :department_id, :cell_phone1, :cell_phone2, :affiliate_date, :hollering_registration)
  end
end
