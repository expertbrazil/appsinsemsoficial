class AppointmentBooksController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize, except: [:confirma, :cancela, :compareceu, :iniciar_atendimento, :finalizar_atendimento], if: :user_signed_in?
  before_action :set_professional
  before_action :set_appointment_book, only: [:show, :edit, :update, :destroy, :confirma, :cancela, :compareceu, :iniciar_atendimento, :finalizar_atendimento]

  # GET /appointment_books
  # GET /appointment_books.json
  def index
    # @appointment_book_peoples = @professional.appointment_book.appointbook_peopleassoci if @professional
    @professionals = Professional.actives

    if params[:identificador_professional].present? 
      if params[:identificador_professional].to_i > 0
        @professional = Professional.find params[:identificador_professional].to_i
        @appointment_book_peoples = @professional.appointment_book.appointbook_peopleassoci if @professional
      end
    else
      @appointment_book_peoples = @professional.appointment_book.appointbook_peopleassoci if @professional
    end
  end

  # GET /appointment_books/1
  # GET /appointment_books/1.json
  def show
    if @appointment_book_people.start_attendance || @appointment_book_people.stop_attendance 
       @conditions = if @appointment_book_people.people_associated_id.nil?
          ["id != ? AND dependent_id = ?", @appointment_book_people.id, @appointment_book_people.dependent_id]
        else
          ["id != ? AND people_associated_id = ?", @appointment_book_people.id, @appointment_book_people.people_associated_id ]
        end

        @all_attendances = @professional.appointment_book.appointbook_peopleassoci.where(@conditions)
      end
  end

  # GET /appointment_books/new
  def new
    @appointment_book_people = @professional.appointment_book.appointbook_peopleassoci.new
    @appointment_book_people.start_datetime = params[:appointment_book][:start_datetime].to_datetime.strftime("%d/%m/%Y %H:%M:%S") if params[:appointment_book] && params[:appointment_book][:start_datetime]
    @appointment_book_people.end_datetime = params[:appointment_book][:end_datetime].to_datetime.strftime("%d/%m/%Y %H:%M:%S") if params[:appointment_book] && params[:appointment_book][:end_datetime]

    respond_to do |format|
      format.js {  }
    end

  end

  # GET /appointment_books/1/edit
  def edit
  end

  # POST /appointment_books
  # POST /appointment_books.json
  def create
    @appointment_book = @professional.appointment_book.appointbook_peopleassoci.new(appointment_book_params)    
    @saved = @appointment_book.save

    respond_to do |format|
      format.js    
    end
  end

  # PATCH/PUT /appointment_books/1
  # PATCH/PUT /appointment_books/1.json
  def update
    @saved = @appointment_book_people.update(appointment_book_params)

    respond_to do |format|
      format.js       
    end
  end

  # DELETE /appointment_books/1
  # DELETE /appointment_books/1.json
  def destroy
    @appointment_book_people.destroy
    respond_to do |format|
      format.js
    end
  end

  def confirma
    @appointment_book_people.confirm!

    respond_to do |format|
      format.js {  }
    end

  end

  def compareceu
    @appointment_book_people.attend!

    respond_to do |format|
      format.js {  }
    end

  end

  def cancela
    @appointment_book_people.cancel!(params[:observation])

    respond_to do |format|
      format.js {  }
    end  
  end  

  def iniciar_atendimento    
    @appointment_book_people.attendance_start!

    @conditions = if @appointment_book_people.people_associated_id.nil?
      ["id != ? AND dependent_id = ?", @appointment_book_people.id, @appointment_book_people.dependent_id]
    else
      ["id != ? AND people_associated_id = ?", @appointment_book_people.id, @appointment_book_people.people_associated_id ]
    end


    @all_attendances = @professional.appointment_book.appointbook_peopleassoci.where(@conditions)

    respond_to do |format|
      format.js {  }
    end
  end

  def finalizar_atendimento
    @appointment_book_people.attendance_stop!
    
   @conditions = if @appointment_book_people.people_associated_id.nil?
      ["id != ? AND dependent_id = ?", @appointment_book_people.id, @appointment_book_people.dependent_id]
    else
      ["id != ? AND people_associated_id = ?", @appointment_book_people.id, @appointment_book_people.people_associated_id ]
    end



    @all_attendances = @professional.appointment_book.appointbook_peopleassoci.where(@conditions)

    respond_to do |format|
      format.js {  }
    end
  end

  
private
    # Use callbacks to share common setup or constraints between actions.
    def set_professional
      @professional = Professional.find(params[:professional_id])
    end

    def set_appointment_book
      @token = params[:id] || params[:appointment_book_id]
      @appointment_book_people = @professional.appointment_book.appointbook_peopleassoci.find(@token)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def appointment_book_params
      params.require(:appointbook_peopleassoci).permit(:start_datetime, :end_datetime, :situation, :people_associated_id, :people_id, :people_type, :observation, :confirmed)
    end
end
