class MemberAccessDependentController < ApplicationController
	before_action :authenticate_dependent!
	layout 'member'

	def index
		@appointment_books_dependents = AppointbookPeopleassoci.where('dependent_id = ?', current_dependent.id)
                                    .order('appointbook_peopleassocis.start_datetime DESC')		
                                    .page(params[:page]).per_page(12)  
	end


	def edit_profile
		@current_dependent = current_dependent
	end

  	def update_profile
  		if params[:dependent][:password].blank?
      		params[:dependent].delete(:password)
      		params[:dependent].delete(:password_confirmation)
    	end


    	if current_dependent.update(dependent_params)
      		redirect_to '/area-dependente', notice: 'Perfil atualizado com sucesso'
    	else
      		respond_to do |format|
      			format.html { render :edit_profile }     
      		end
    	end
  	end

private
  # Never trust parameters from the scary internet, only allow the white list through.
  def dependent_params
    params.require(:dependent).permit(:name, :username, :password, :password_confirmation, :phone, :cell_phone)
  end
end
