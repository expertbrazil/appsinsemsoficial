class SubcategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize, if: :user_signed_in?
  before_action :set_subcategory, only: [:show, :edit, :update, :destroy]

  # GET /subcategories
  # GET /subcategories.json
  def index
    @subcategories = Subcategory.paginate(page: params[:page])
  end

  # GET /subcategories/1
  # GET /subcategories/1.json
  def show
  end

  # GET /subcategories/new
  def new
    @subcategory = Subcategory.new
  end

  # GET /subcategories/1/edit
  def edit
  end

  # POST /subcategories
  # POST /subcategories.json
  def create
    @subcategory = Subcategory.new(subcategory_params)
    @saved = @subcategory.save

    respond_to do |format|
      if @saved
        @url =  params[:create_and_add] ? new_subcategory_url : subcategories_url  
        format.html { redirect_to @url, notice: "#{Subcategory.model_name.human} #{I18n.t('default_messages.created')}" }        
        format.json { render :show, status: :created, location: @subcategory }
        format.js
      else
        format.html { render :new }
        format.json { render json: @subcategory.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /subcategories/1
  # PATCH/PUT /subcategories/1.json
  def update
    respond_to do |format|
      if @subcategory.update(subcategory_params)
        format.html { redirect_to subcategories_url, notice: "#{Subcategory.model_name.human} #{I18n.t('default_messages.updated')}" }
        format.json { render :show, status: :ok, location: @subcategory }
      else
        format.html { render :edit }
        format.json { render json: @subcategory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subcategories/1
  # DELETE /subcategories/1.json
  def destroy
    @subcategory.destroy
    respond_to do |format|
      format.html { redirect_to subcategories_url, notice: "#{Subcategory.model_name.human} #{I18n.t('default_messages.destroyed')}" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subcategory
      @subcategory = Subcategory.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def subcategory_params
      params.require(:subcategory).permit(:reduced_code, :name, :type_subcategory, :status)
    end
end