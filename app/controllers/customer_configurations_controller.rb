class CustomerConfigurationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize, if: :user_signed_in?
  before_action :set_customer_configuration, only: [:show, :edit, :update, :destroy]

  # GET /customer_configurations
  # GET /customer_configurations.json
  def index
    @customer_configurations = CustomerConfiguration.page params[:page]
  end

  # GET /customer_configurations/1
  # GET /customer_configurations/1.json
  def show
  end

  # GET /customer_configurations/new
  def new
    @customer_configuration = CustomerConfiguration.new
  end

  # GET /customer_configurations/1/edit
  def edit
  end

  # POST /customer_configurations
  # POST /customer_configurations.json
  def create
    @customer_configuration = CustomerConfiguration.new(customer_configuration_params)

    respond_to do |format|
      if @customer_configuration.save
        @url =  params[:create_and_add] ? new_customer_configuration_url : customer_configurations_url        
        format.html { redirect_to @url, notice: "#{CustomerConfiguration.model_name.human} #{I18n.t('default_messages.created')}" }           
        format.json { render :show, status: :created, location: @customer_configuration }
      else
        format.html { render :new }
        format.json { render json: @customer_configuration.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customer_configurations/1
  # PATCH/PUT /customer_configurations/1.json
  def update
    respond_to do |format|
      if @customer_configuration.update(customer_configuration_params)
        format.html { redirect_to customer_configurations_url, notice: "#{CustomerConfiguration.model_name.human} #{I18n.t('default_messages.updated')}" }
        format.json { render :show, status: :ok, location: @customer_configuration }
      else
        format.html { render :edit }
        format.json { render json: @customer_configuration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customer_configurations/1
  # DELETE /customer_configurations/1.json
  def destroy
    @customer_configuration.destroy
    respond_to do |format|
      format.html { redirect_to customer_configurations_url, notice: "#{CustomerConfiguration.model_name.human} #{I18n.t('default_messages.destroyed')}" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer_configuration
      @customer_configuration = CustomerConfiguration.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def customer_configuration_params
      params.require(:customer_configuration).permit(:idade_limite_estudante, :menu_people_associateds, :name, :address, :city, :state, :cnpj, :phone, :cell_phone, :date_fundation, :logo, :street, :president, :ficha, :total_maximum_salary, :discount_percentage, :signature)
    end
end
