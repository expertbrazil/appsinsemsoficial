class PeopleAssociatedsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize, except: [:autocomplete, :search, :wallet, :record, :print, :find_by_cpf, :affiliation_requirement, :affiliate_statement, :stable_union_statement, :affiliate_defiliation, :load_all, :declaration_of_dependency, :my_dependents, :clear_all_in_analysis], if: :user_signed_in?
  before_action :set_people_associated, only: [:show, :edit, :update, :destroy]
  
  # GET /people_associateds
  # GET /people_associateds.json
  def index
    #@people_associateds = PeopleAssociated.paginate(page: params[:page])

      @filterrific = initialize_filterrific(
          PeopleAssociated,
          params[:filterrific],
          select_options: {
            sorted_by: PeopleAssociated.options_for_sorted_by
          },
          default_filter_params: { sorted_by: 'number_registration_asc' }
        ) or return
        
      @people_associateds = @filterrific.find.page(params[:page])
      @people_associateds_in_analysis = PeopleAssociated.in_analysis

      respond_to do |format|
          format.html
          format.js
      end
  end

  def people_associateds_to_xls
      @filterrific = initialize_filterrific(
        PeopleAssociated,
        params[:filterrific],
        select_options: {
          sorted_by: PeopleAssociated.options_for_sorted_by
        },
        default_filter_params: { sorted_by: 'number_registration_asc' }
      ) or return

      @people_associateds = @filterrific.find

      to_export = []
      @people_associateds.each do |people_associated|
        to_export << {
          "Nome": people_associated.name,
          "Endereço completo": "#{people_associated.address},#{people_associated.number},#{people_associated.complement}",
          "Cidade": people_associated.city,
          "Estado": people_associated.state,
          "Bairro": people_associated.burgh,
          "CEP": people_associated.zipcode,
          "CPF": people_associated.cpf,
          "RG": people_associated.rg,
          "E-mail": people_associated.email,
          "Fone": people_associated.phone,
          "Celular": people_associated.cell_phone1,
          "Departamento": people_associated.office.present? ? people_associated.office.name : '',
          "Matrícula": people_associated.hollering_registration,
          "Secretaria": people_associated.department.present? ? people_associated.department.name : '',
        }.compact
      end

      to_export << {"Sem Resultados": ""} if to_export.blank?

      respond_to do |format|
        format.xls { send_data(to_export.to_xls, filename: "#{CustomerConfiguration.current.menu_people_associateds}_#{Date.current.strftime("%d_%m_%Y")}.xls") }
      end
  end

  def print
    @filterrific = initialize_filterrific(
        PeopleAssociated,
        params[:filterrific],
        select_options: {
          sorted_by: PeopleAssociated.options_for_sorted_by
        },
        default_filter_params: { sorted_by: 'number_registration_asc' }
      ) or return
      
    @people_associateds = @filterrific.find

    respond_to do |format|
      format.html { render layout: false }
    end
  end

  # GET /people_associateds/1
  # GET /people_associateds/1.json
  def show
  end

  # GET /people_associateds/new
  def new
    @people_associated = PeopleAssociated.new
    @people_associated.number_registration = PeopleAssociated.next_number_registration    
  end

  # GET /people_associateds/1/edit
  def edit
  end

  # POST /people_associateds
  # POST /people_associateds.json
  def create
    @people_associated = PeopleAssociated.new(people_associated_params)

    respond_to do |format|
      if @people_associated.save
        @url =  params[:create_and_add] ? new_people_associated_url : people_associateds_url 
        format.html { redirect_to @url, notice: "#{PeopleAssociated.model_name.human} #{I18n.t('default_messages.created')}" }
        format.json { render :show, status: :created, location: @people_associated }
      else
        format.html { render :new }
        format.json { render json: @people_associated.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people_associateds/1
  # PATCH/PUT /people_associateds/1.json
  def update
    if params[:people_associated][:password].blank?
      params[:people_associated].delete("password")
      params[:people_associated].delete("password_confirmation")
    end


    if !params[:people_associated][:photo].blank? && params[:people_associated][:photo] ==  @people_associated.photo_url
      params[:people_associated].delete("photo")
    end

    respond_to do |format|
      if @people_associated.update(people_associated_params)
        format.html { redirect_to people_associateds_url, notice: "#{PeopleAssociated.model_name.human} #{I18n.t('default_messages.updated')}" }
        format.json { render :show, status: :ok, location: @people_associated }
      else
        format.html { render :edit }
        format.json { render json: @people_associated.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people_associateds/1
  # DELETE /people_associateds/1.json
  def destroy
    @people_associated.destroy
    respond_to do |format|
      format.html { redirect_to people_associateds_url, notice: "#{PeopleAssociated.model_name.human} #{I18n.t('default_messages.destroyed')}" }
      format.json { head :no_content }
    end
  end

  def autocomplete
    if params[:q]
      @people_associateds = PeopleAssociated.search_by_name(params[:q])
    else
      @people_associateds = PeopleAssociated.find_by_id(params[:id])
    end

    respond_to do |format|
      format.json
      # format.json { render :json => { :people_associateds => @people_associateds }}
    end
  end

  def search
    @people_associateds = PeopleAssociated.search(params[:search])
  end

  def wallet
    @p = PeopleAssociated.find(params[:id])
    render layout: 'print'
  end

  def record
    @p = PeopleAssociated.find(params[:id])
    render layout: 'print'
  end  

  def affiliate_statement
    if params && params[:id].present? && !params[:id].blank?
      @p = PeopleAssociated.find(params[:id])
      respond_to do |format|
        format.html {render layout: 'print'}
        format.js {}
      end  
    else
      respond_to do |format|
        format.html { render text: 'Informe o associado!' }
      end
    end
  end  

  def stable_union_statement
    if params && params[:id].present? && !params[:id].blank?
      @p = PeopleAssociated.find(params[:id])
      respond_to do |format|
        format.html {render layout: 'print'}
        format.js {}
      end  
    else
      respond_to do |format|
        format.html { render text: 'Informe o associado!' }
      end
    end
  end
  
  def affiliate_defiliation
    if params && params[:id].present? && !params[:id].blank?
      @p = PeopleAssociated.find(params[:id])
      respond_to do |format|
        format.html {render layout: 'print'}
        format.js {}
      end  
    else
      respond_to do |format|
        format.html { render text: 'Informe o associado!' }
      end
    end
  end

  def declaration_of_dependency
    if params && params[:id].present? && !params[:id].blank?
      @p = PeopleAssociated.find(params[:id])
      @dependents = @p.dependents.where("id IN (?)", params[:dependent_ids].split(','))  if params && params[:dependent_ids].present? && !params[:dependent_ids].blank?

      respond_to do |format|
        format.html {render layout: 'print'}
        format.js {}
      end  
    else
      respond_to do |format|
        format.html { render text: 'Informe o associado!' }
      end
    end
  end

  def affiliation_requirement  
    if params && params[:id].present? && !params[:id].blank?
      @p = PeopleAssociated.find(params[:id])
      respond_to do |format|
        format.html {render layout: 'print'}
        format.js {}
      end  
    else
      respond_to do |format|
        format.html { render text: 'Informe o associado!' }
      end
    end  
  end

  def find_by_cpf 
    @people_associated = PeopleAssociated.select(:id, :name).find_by_cpf(params[:cpf]) if params[:cpf]
    
    respond_to do |format|
      format.json { render :json => { :people_associated => @people_associated, in_use: @people_associated.present? }}
    end   
  end

  def load_all
    @people_associateds = PeopleAssociated.all
    @data_url = params[:data_url]

    respond_to do |format|
      format.js {}
    end   
  end

  def my_dependents
    @people_associated = PeopleAssociated.find(params[:id])
    @dependents = @people_associated.dependents

    respond_to do |format|
      format.js {}
    end   
  end

  def clear_all_in_analysis
    PeopleAssociated.update_all(in_analysis: false)
    
    respond_to do |format|
      format.js {}
    end  
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_people_associated
      @people_associated = PeopleAssociated.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def people_associated_params
      params.require(:people_associated).permit(:username, :password, :password_confirmation, :number_registration, :name, :birthdate, :gender, :email, :phone, :address, :number, :complement, :zipcode, :burgh, :city, :state, :cpf, :rg, :marital_status, :place_birth, :scholarity, :profession, :photo, :situation, :mother, :father, :breed, :title_voter, :zone_voter, :section_voter, :workplace_id, :admission_date, :bond, :validity_card, :partner, :dispatcher_organ, :father_mother, :created_at, :start_registration, :office_id, :occupation_id, :spouse, :parading_date, :department_id, :observation, :cell_phone1, :cell_phone2, :affiliate_date, :hollering_registration, :discount_percentage, :fixed_value, :gross_salary, system_attachments_attributes: [:id, :name, :archive, :_destroy], dependents_attributes: [:id, :name, :institution_name, :birthdate, :degree_of_kinship, :other_manual, :validate_statement, :with_special_needs, :active, :benefit_until, :phone, :cell_phone, :cpf, :rg, :dispatcher_organ, :is_student, :username, :password, :password_confirmation, :_destroy, system_attachments_attributes: [:id, :name, :archive, :_destroy]])
    end
  end
