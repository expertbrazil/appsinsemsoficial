class FinancialAccountsController < ApplicationController
  before_action :authenticate_user!
  # before_action :authorize, if: :user_signed_in?
  before_action :set_financial_account, only: [:show, :edit, :update, :destroy]

  # GET /financial_accounts
  # GET /financial_accounts.json
  def index
    @financial_accounts = FinancialAccount.page params[:page]
  end

  # GET /financial_accounts/1
  # GET /financial_accounts/1.json
  def show
  end

  # GET /financial_accounts/new
  def new
    @financial_account = FinancialAccount.new
  end

  # GET /financial_accounts/1/edit
  def edit
  end

  # POST /financial_accounts
  # POST /financial_accounts.json
  def create
    @financial_account = FinancialAccount.new(financial_account_params)
    @saved = @financial_account.save
    
    respond_to do |format|
      if @saved
        @url =  params[:create_and_add] ? new_financial_account_url : financial_accounts_url        
        format.html { redirect_to @url, notice: "#{FinancialAccount.model_name.human} #{I18n.t('default_messages.created')}" }
        format.json { render :show, status: :created, location: @financial_account }
        format.js
      else
        format.html { render :new }
        format.json { render json: @financial_account.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /financial_accounts/1
  # PATCH/PUT /financial_accounts/1.json
  def update
    respond_to do |format|
      if @financial_account.update(financial_account_params)
        format.html { redirect_to financial_accounts_url, notice:  "#{FinancialAccount.model_name.human} #{I18n.t('default_messages.updated')}"  }
        format.json { render :show, status: :ok, location: @financial_account }
      else
        format.html { render :edit }
        format.json { render json: @financial_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /financial_accounts/1
  # DELETE /financial_accounts/1.json
  def destroy
    @financial_account.destroy
    respond_to do |format|
      format.html { redirect_to financial_accounts_url, notice: "#{FinancialAccount.model_name.human} #{I18n.t('default_messages.destroyed')}" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_financial_account
      @financial_account = FinancialAccount.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def financial_account_params
      params.require(:financial_account).permit(:name, :status)
    end
end
