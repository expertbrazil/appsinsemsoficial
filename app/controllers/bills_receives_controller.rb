class BillsReceivesController < ApplicationController
  before_action :authenticate_user!
  # before_action :authorize, if: :user_signed_in?
  before_action :set_bills_receife, only: [:show, :edit, :update, :destroy]

  # GET /bills_receives
  # GET /bills_receives.json
  def index
    # @bills_receives = BillsReceife.paginate(page: params[:page])

        @filterrific = initialize_filterrific(
          BillsReceife,
          params[:filterrific],
          select_options: {
            sorted_by: BillsReceife.options_for_sorted_by
          },
          default_filter_params: { sorted_by: '' }
        ) or return
        
      @bills_receives = @filterrific.find.page(params[:page])

      respond_to do |format|
          format.html
          format.js
      end


  end

  # GET /bills_receives/1
  # GET /bills_receives/1.json
  def show
  end

  # GET /bills_receives/new
  def new
    if params[:bills_pay_id].present?  
      @bills_pay = BillsPay.find(params[:bills_pay_id])

      if @bills_pay.bills_receife.nil?

        @bills_receife = BillsReceife.new(
            people_associated_id: @bills_pay.people_associated_id, 
            description: @bills_pay.description, 
            amount: @bills_pay.amount, 
            competence_date: @bills_pay.competence_date, 
            due_date: @bills_pay.due_date, 
            ocorrence: @bills_pay.ocorrence, 
            deadline: @bills_pay.deadline, 
            expiration_day: @bills_pay.expiration_day,           
            work_days_only: @bills_pay.work_days_only,
            bills_pay_id: @bills_pay.id      
          );
      else
        @bills_receife = @bills_pay.bills_receife
      end
    else
      @bills_receife = BillsReceife.new
    end
  end

  # GET /bills_receives/1/edit
  def edit
  end

  # POST /bills_receives
  # POST /bills_receives.json
  def create
    @bills_receife = BillsReceife.new(bills_receife_params)
    @saved = @bills_receife.save
    respond_to do |format|
      if  @saved
        @url =  params[:create_and_add] ? new_bill_receive_url : bills_receives_url        
        format.html { redirect_to @url, notice: "#{BillsReceife.model_name.human} #{I18n.t('default_messages.created')}" }
        format.json { render :show, status: :created, location: @bills_receife }
        format.js
      else
        format.html { render :new }
        format.json { render json: @bills_receife.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /bills_receives/1
  # PATCH/PUT /bills_receives/1.json
  def update
    @saved = @bills_receife.update(bills_receife_params)
    respond_to do |format|
      if @saved
        format.html { redirect_to @bills_receife, notice: "#{BillsReceife.model_name.human} #{I18n.t('default_messages.updated')}"}
        format.json { render :show, status: :ok, location: @bills_receife }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @bills_receife.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /bills_receives/1
  # DELETE /bills_receives/1.json
  def destroy
    @bills_receife.destroy
    respond_to do |format|
      format.html { redirect_to bills_receives_url, notice: "#{BillsReceife.model_name.human} #{I18n.t('default_messages.destroyed')}"}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bills_receife
      @bills_receife = BillsReceife.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bills_receife_params
      params.require(:bills_receife).permit(:bank_account_id, :people_associated_id, :category_id, :financial_account_id, :stop_recurrence, :payment_form_id, :state, :due_date, :description, :amount, :n_doc, :competence_date, :attachment, :ocorrence, :deadline, :expiration_day, :work_days_only, :bills_pay_id, system_attachments_attributes: [:id, :name, :archive, :_destroy])
    end
end
