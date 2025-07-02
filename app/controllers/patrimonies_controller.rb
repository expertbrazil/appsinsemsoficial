class PatrimoniesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize, if: :user_signed_in?
  before_action :set_patrimony, only: [:show, :edit, :update, :destroy]

  # GET /patrimonies
  # GET /patrimonies.json
  def index
    @patrimonies = Patrimony.paginate(page: params[:page])
  end

  # GET /patrimonies/1
  # GET /patrimonies/1.json
  def show
  end

  # GET /patrimonies/new
  def new
    @patrimony = Patrimony.new
  end

  # GET /patrimonies/1/edit
  def edit
  end

  # POST /patrimonies
  # POST /patrimonies.json
  def create
    @patrimony = Patrimony.new(patrimony_params)

    respond_to do |format|
      if @patrimony.save
        @url =  params[:create_and_add] ? new_patrimony_url : patrimonies_url 
        format.html { redirect_to @url, notice: "#{Patrimony.model_name.human} #{I18n.t('default_messages.created')}" }
        format.json { render :show, status: :created, location: @patrimony }
      else
        format.html { render :new }
        format.json { render json: @patrimony.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /patrimonies/1
  # PATCH/PUT /patrimonies/1.json
  def update
    respond_to do |format|
      if @patrimony.update(patrimony_params)
        format.html { redirect_to patrimonies_url, notice: "#{Patrimony.model_name.human} #{I18n.t('default_messages.updated')}" }
        format.json { render :show, status: :ok, location: @patrimony }
      else
        format.html { render :edit }
        format.json { render json: @patrimony.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /patrimonies/1
  # DELETE /patrimonies/1.json
  def destroy
    @patrimony.destroy
    respond_to do |format|
      format.html { redirect_to patrimonies_url, notice: "#{Patrimony.model_name.human} #{I18n.t('default_messages.destroyed')}"  }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_patrimony
      @patrimony = Patrimony.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def patrimony_params
      params.require(:patrimony).permit(:inactive_describe, :type_incorporation_describe, :effort_describe, :request_of, :entry_note, :current_amount, :type_incorporation_id, :date_of_incorporation, :supplier_id, :effort_id, :room_id, :name, :description, :quantity, :date_of_acquisition, :amount, :patrimony_number, :active, :car, :type_car, :year_car)
    end
end
