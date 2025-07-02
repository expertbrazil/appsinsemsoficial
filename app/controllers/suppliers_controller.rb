class SuppliersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_supplier, only: [:show, :edit, :update, :destroy]

  # GET /suppliers
  # GET /suppliers.json
  def index
    @suppliers = Supplier.paginate(page: params[:page])
  end

  # GET /suppliers/1
  # GET /suppliers/1.json
  def show
  end

  # GET /suppliers/new
  def new
    @supplier = Supplier.new
  end

  # GET /suppliers/1/edit
  def edit
  end

  # POST /suppliers
  # POST /suppliers.json
  def create
    @supplier = Supplier.new(supplier_params)
    @saved = @supplier.save
    
    respond_to do |format|
      if @saved
        format.html { redirect_to suppliers_url, notice: "#{Supplier.model_name.human} #{I18n.t('default_messages.created')}" }
        format.json { render :show, status: :created, location: @supplier }
        format.js
      else
        format.html { render :new }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /suppliers/1
  # PATCH/PUT /suppliers/1.json
  def update
    respond_to do |format|
      if @supplier.update(supplier_params)
        format.html { redirect_to suppliers_url, notice: "#{Supplier.model_name.human} #{I18n.t('default_messages.updated')}" }
        format.json { render :show, status: :ok, location: @supplier }
      else
        format.html { render :edit }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /suppliers/1
  # DELETE /suppliers/1.json
  def destroy
    @supplier.destroy
    respond_to do |format|
      format.html { redirect_to suppliers_url, notice: "#{Supplier.model_name.human} #{I18n.t('default_messages.destroyed')}" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplier
      @supplier = Supplier.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supplier_params
      params.require(:supplier).permit(:status, :name, :phone, :email, :entity_type, :razao_social, :cnpj, :cpf, :rg, :emitter, :uf, :cell_phone, :address, :complement, :number, :zipcode, :burgh, :city, :state, :obs)
    end
end
