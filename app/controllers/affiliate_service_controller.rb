class AffiliateServiceController < ApplicationController
  before_action :authenticate_user!
  # before_action :authorize, except: [:confirma, :cancela, :compareceu], if: :user_signed_in?

  def appointment_book
  	@professionals = Professional.actives

  	if params[:identificador_professional].present? 
	  	if params[:identificador_professional].to_i > 0
	  		@professional = Professional.find params[:identificador_professional].to_i
	  		@appointment_book_peoples = @professional.appointment_book.appointbook_peopleassoci if @professional
	  	end
  	end
  end

  def update_appointbook_peopleassoci
    @appointment_book_people = AppointbookPeopleassoci.find(params[:appointbook_peopleassoci_id]) if params[:appointbook_peopleassoci_id].present? 

    if !@appointment_book_people.nil?

      @appointment_book_people.update(appointbook_peopleassoci_params)

      @conditions = if @appointment_book_people.people_associated_id.nil?
        ["id != ? AND dependent_id = ?", @appointment_book_people.id, @appointment_book_people.dependent_id]
      else
        ["id != ? AND people_associated_id = ?", @appointment_book_people.id, @appointment_book_people.people_associated_id ]
      end

      @professional = @appointment_book_people.appointment_book.professional
      @all_attendances = @professional.appointment_book.appointbook_peopleassoci.where(@conditions)
    end

    respond_to do |format|
      format.js {  }
    end
  end



  
private
    # Never trust parameters from the scary internet, only allow the white list through.
    def appointbook_peopleassoci_params
      params.require(:appointbook_peopleassoci).permit(:description, :situation, :observation, :confirmed)
    end

end
