class ProfessionalsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize, if: :user_signed_in?
  before_action :set_professional, only: [:show, :edit, :update, :destroy]

  # GET /professionals
  # GET /professionals.json
  def index
    @professionals = Professional.paginate(page: params[:page])
  end

  # GET /professionals/1
  # GET /professionals/1.json
  def show
  end

  # GET /professionals/new
  def new
    @professional = Professional.new
  end

  # GET /professionals/1/edit
  def edit
  end

  # POST /professionals
  # POST /professionals.json
  def create
    @professional = Professional.new(professional_params)

    respond_to do |format|
      if @professional.save
        # cria a agenda
        @professional.create_appointment_book
        @url =  params[:create_and_add] ? new_professional_url : professionals_url 
        format.html { redirect_to @url, notice: "#{Professional.model_name.human} #{I18n.t('default_messages.created')}" }
        format.json { render :show, status: :created, location: @professional }
      else
        format.html { render :new }
        format.json { render json: @professional.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /professionals/1
  # PATCH/PUT /professionals/1.json
  def update
    respond_to do |format|
      if @professional.update(professional_params)        
        @professional.user.update_attribute(:active, @professional.active) if @professional.saved_change_to_active?
        

        format.html { redirect_to professionals_url, notice: "#{Professional.model_name.human} #{I18n.t('default_messages.updated')}" }
        format.json { render :show, status: :ok, location: @professional }
      else
        format.html { render :edit }
        format.json { render json: @professional.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /professionals/1
  # DELETE /professionals/1.json
  def destroy
    # remove a agenda
    @professional.destroy_appointment_book    
    @professional.destroy    
    

    respond_to do |format|
      format.html { redirect_to professionals_url, notice: "#{Professional.model_name.human} #{I18n.t('default_messages.destroyed')}" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_professional
      @professional = Professional.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def professional_params
      params.require(:professional).permit(:active, :name, :cpf, :rg, :advice, :type_function)
    end
end
