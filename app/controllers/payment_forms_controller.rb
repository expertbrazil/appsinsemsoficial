class PaymentFormsController < ApplicationController
  before_action :set_payment_form, only: [:show, :edit, :update, :destroy]

  # GET /payment_forms
  # GET /payment_forms.json
  def index
    @payment_forms = PaymentForm.page params[:page]
  end

  # GET /payment_forms/1
  # GET /payment_forms/1.json
  def show
  end

  # GET /payment_forms/new
  def new
    @payment_form = PaymentForm.new
  end

  # GET /payment_forms/1/edit
  def edit
  end

  # POST /payment_forms
  # POST /payment_forms.json
  def create
    @payment_form = PaymentForm.new(payment_form_params)
    @saved = @payment_form.save
    respond_to do |format|
      if @saved
        @url =  params[:create_and_add] ? new_payment_form_url : payment_forms_url        
        format.html { redirect_to @url, notice: "#{PaymentForm.model_name.human} #{I18n.t('default_messages.created')}" }
        format.json { render :show, status: :created, location: @payment_form }
        format.js
      else
        format.html { render :new }
        format.json { render json: @payment_form.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /payment_forms/1
  # PATCH/PUT /payment_forms/1.json
  def update
    respond_to do |format|
      if @payment_form.update(payment_form_params)
        format.html { redirect_to payment_forms_url, notice: "#{PaymentForm.model_name.human} #{I18n.t('default_messages.updated')}" }
        format.json { render :show, status: :ok, location: @payment_form }
      else
        format.html { render :edit }
        format.json { render json: @payment_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_forms/1
  # DELETE /payment_forms/1.json
  def destroy
    @payment_form.destroy
    respond_to do |format|
      format.html { redirect_to payment_forms_url, notice: "#{PaymentForm.model_name.human} #{I18n.t('default_messages.destroyed')}" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_form
      @payment_form = PaymentForm.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def payment_form_params
      params.require(:payment_form).permit(:name, :status)
    end
end
