class DependentsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize, if: :user_signed_in?
  before_action :set_people_associated
  before_action :set_dependent, only: [:show, :edit, :update, :destroy]
  
  # GET /dependents
  # GET /dependents.json
  def index
    #@dependents = @people_associated.dependents
    filterrific
  end

  # GET /dependents/1
  # GET /dependents/1.json
  def show
  end

  # GET /dependents/new
  def new
    @dependent = @people_associated.dependents.new
  end

  # GET /dependents/1/edit
  def edit
  end

  # POST /dependents
  # POST /dependents.json
  def create
    @dependent = @people_associated.dependents.new(dependent_params)
    filterrific
    @saved = @dependent.save

    respond_to do |format|
      if @saved
        format.html { redirect_to @dependent, notice: "#{Dependent.model_name.human} #{I18n.t('default_messages.created')}" }
        format.json { render :show, status: :created, location: @dependent }
        format.js
      else
        format.html { render :new }
        format.json { render json: @dependent.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /dependents/1
  # PATCH/PUT /dependents/1.json
  def update

    if params[:dependent][:password].blank?
      params[:dependent].delete("password")
      params[:dependent].delete("password_confirmation")
    end

    respond_to do |format|
      filterrific

      @saved = @dependent.update(dependent_params)      

      if @saved  
        format.html { redirect_to @dependent, notice: "#{Dependent.model_name.human} #{I18n.t('default_messages.updated')}" }
        format.json { render :show, status: :ok, location: @people_associated }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @dependent.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /dependents/1
  # DELETE /dependents/1.json
  def destroy
    @dependent.destroy
    filterrific

    respond_to do |format|
      format.html { redirect_to dependents_url, notice: "#{Dependent.model_name.human} #{I18n.t('default_messages.destroyed')}" }
      format.json { head :no_content }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_people_associated
      @people_associated = PeopleAssociated.find(params[:people_associated_id])
    end

    def set_dependent
      @dependent = @people_associated.dependents.find(params[:id])
    end

    def filterrific
      @filterrific = initialize_filterrific(
          Dependent.joins(:people_associated),
          params[:filterrific],
          default_filter_params: { sorted_by: 'created_at_desc', with_people_associated_id: @people_associated.id },
          persistence_id: false
        ) or return
        
      @dependents = @filterrific.find.page(params[:page])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dependent_params
      params.require(:dependent).permit(:is_student, :phone, :cell_phone, :username, :password, :password_confirmation, :people_associated_id, :name, :birthdate, :degree_of_kinship, :other_manual, :benefit_until, :validate_statement, :with_special_needs, :active, system_attachments_attributes: [:id, :name, :archive, :_destroy])
    end
end
