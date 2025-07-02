class MonthlyPaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize, if: :user_signed_in?
  before_action :set_monthly_payment, only: [:show, :edit, :update, :destroy, :pay]

  # GET /monthly_payments
  # GET /monthly_payments.json
  def index
    @filterrific = initialize_filterrific(
        MonthlyPayment,
        params[:filterrific],
        select_options: {
          sorted_by: MonthlyPayment.options_for_sorted_by
        },
        default_filter_params: { sorted_by: 'due_date_asc' }
      ) or return
      
    @monthly_payments = @filterrific.find.page(params[:page])
    # @monthly_payments = MonthlyPayment.page(params[:page])

    respond_to do |format|
        format.html
        format.js
    end          
  end

  # GET /monthly_payments/1
  # GET /monthly_payments/1.json
  def show
  end

  # GET /monthly_payments/new
  def new
    @monthly_payment = MonthlyPayment.new
  end

  # GET /monthly_payments/1/edit
  def edit
  end

  # POST /monthly_payments
  # POST /monthly_payments.json
  def create
    @monthly_payment = MonthlyPayment.new(monthly_payment_params)

    respond_to do |format|
      if @monthly_payment.save
        if params[:repeat].present?
          MonthlyPayment.newRecurrence(@monthly_payment, params[:period], params[:quantity])
        end

        format.html { redirect_to monthly_payments_url, notice: "#{MonthlyPayment.model_name.human} #{I18n.t('default_messages.created')}" }
        format.json { render :show, status: :created, location: @monthly_payment }
      else
        format.html { render :new }
        format.json { render json: @monthly_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /monthly_payments/1
  # PATCH/PUT /monthly_payments/1.json
  def update
    respond_to do |format|
      if @monthly_payment.update(monthly_payment_params)
        format.html { redirect_to monthly_payments_url, notice: "#{MonthlyPayment.model_name.human} #{I18n.t('default_messages.updated')}" }
        format.json { render :show, status: :ok, location: @monthly_payment }
      else
        format.html { render :edit }
        format.json { render json: @monthly_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /monthly_payments/1
  # DELETE /monthly_payments/1.json
  def destroy
    @monthly_payment.destroy
    respond_to do |format|
      format.html { redirect_to monthly_payments_url, notice: "#{MonthlyPayment.model_name.human} #{I18n.t('default_messages.destroyed')}" }
      format.json { head :no_content }
    end
  end

  def pay
      if request.patch?
        @monthly_payment.update_attributes(observation: monthly_payment_params[:observation], pay_day: (monthly_payment_params[:pay_day] || Date.current), paid: true, amount_paid: monthly_payment_params[:amount_paid])
      end

      respond_to do |format|
        format.js
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_monthly_payment
      @token = params[:id] || params[:monthly_payment_id]
      @monthly_payment = MonthlyPayment.find(@token)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def monthly_payment_params
      params.require(:monthly_payment).permit(:people_associated_id, :amount, :amount_paid, :due_date, :pay_day, :paid, :observation)
    end
end
