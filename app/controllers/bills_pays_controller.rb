class BillsPaysController < ApplicationController
  before_action :set_bills_pay, only: [:show, :edit, :update, :destroy]
 skip_before_action :verify_authenticity_token

  # GET /bills_pays
  # GET /bills_pays.json
  def index
    # @bills_pays = BillsPay.page params[:page]

    @filterrific = initialize_filterrific(
          BillsPay,
          params[:filterrific],
          select_options: {
            sorted_by: BillsPay.options_for_sorted_by
          },
          default_filter_params: { sorted_by: '' }
        ) or return
        
      @bills_pays = @filterrific.find.page(params[:page])

      respond_to do |format|
          format.html
          format.js
      end


  end

  # GET /bills_pays/1
  # GET /bills_pays/1.json
  def show
  end

  # GET /bills_pays/new
  def new
    @bills_pay = BillsPay.new
  end

  # GET /bills_pays/1/edit
  def edit
  end

  # POST /bills_pays
  # POST /bills_pays.json
  def create
    @bills_pay = BillsPay.new(bills_pay_params)
    @saved = @bills_pay.save

    respond_to do |format|
      if @saved
        @url =  params[:create_and_add] ? new_bills_pay_url : bills_pays_url
        format.html { redirect_to @url, notice: "#{BillsPay.model_name.human} #{I18n.t('default_messages.created')}" }
        format.json { render :show, status: :created, location: @bills_pay }
        format.js 
      else
        format.js
        format.html { render :new }
        format.json { render json: @bills_pay.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bills_pays/1
  # PATCH/PUT /bills_pays/1.json
  def update
    @saved = @bills_pay.update(bills_pay_params)
    respond_to do |format|
      if @saved
        @url = @bills_pay.bills_receife.nil? ? new_bills_receife_path({ bills_pay_id: @bills_pay.id }) : edit_bills_receife_path(@bills_pay.bills_receife)
        format.html { redirect_to @bills_pay, notice: "#{BillsPay.model_name.human} #{I18n.t('default_messages.updated')}" }
        format.json { render :show, status: :ok, location: @bills_pay }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @bills_pay.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /bills_pays/1
  # DELETE /bills_pays/1.json
  def destroy
    @bills_pay.destroy
    respond_to do |format|
      format.html { redirect_to bills_pays_url, notice: "#{BillsPay.model_name.human} #{I18n.t('default_messages.destroyed')}" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bills_pay
      @bills_pay = BillsPay.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bills_pay_params
      params.require(:bills_pay).permit(:bank_account_id, :supplier_id, :people_associated_id, :payment_form_id, :category_id, :payroll_discount, :due_date, :description, :amount, :n_doc, :competence_date, :ocorrence, :expiration_day, :deadline, :work_days_only, :receive, :next_in, :receive_date, :stop_recurrence, :state_assm, system_attachments_attributes: [:id, :name, :archive, :_destroy])
    end
end
