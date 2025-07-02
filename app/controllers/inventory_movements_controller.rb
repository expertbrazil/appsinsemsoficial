class InventoryMovementsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize, if: :user_signed_in?
  before_action :set_inventory
  before_action :set_inventory_movement, only: [:show, :edit, :update, :destroy]

  # GET /inventory_movements
  # GET /inventory_movements.json
  def index
    @inventory_movements = @inventory.inventory_movements
  end

  # GET /inventory_movements/1
  # GET /inventory_movements/1.json
  def show
  end

  # GET /inventory_movements/new
  def new
    @inventory_movement = @inventory.inventory_movements.new
  end

  # GET /inventory_movements/1/edit
  def edit
  end

  # POST /inventory_movements
  # POST /inventory_movements.json
  def create
    @inventory_movement = @inventory.inventory_movements.new(inventory_movement_params)
    @saved = @inventory_movement.save
    
    respond_to do |format|
      format.js      
    end
  end

  # PATCH/PUT /inventory_movements/1
  # PATCH/PUT /inventory_movements/1.json
  def update
    respond_to do |format|
      if @inventory_movement.update(inventory_movement_params)
        @url =  params[:create_and_add] ? new_inventory_movement_url : inventory_movements_url 

        format.html { redirect_to @url, notice: 'Inventory movement was successfully updated.' }
        format.json { render :show, status: :ok, location: @inventory_movement }
      else
        format.html { render :edit }
        format.json { render json: @inventory_movement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inventory_movements/1
  # DELETE /inventory_movements/1.json
  def destroy
    @inventory_movement.destroy
    respond_to do |format|
      format.html { redirect_to inventory_movements_url, notice: 'Inventory movement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inventory
      @inventory = Inventory.find(params[:inventory_id])
    end

    def set_inventory_movement
      @inventory_movement = @inventory.inventory_movements.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def inventory_movement_params
      params.require(:inventory_movement).permit(:inventory_id, :type_balance, :balance, :amount)
    end
  end
