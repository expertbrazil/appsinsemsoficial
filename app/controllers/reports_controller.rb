class ReportsController < ApplicationController
	before_action :authenticate_user!
  before_action :authorize, except: [:print_dependents, :associateds_print, :associateds_xml, :birthdays_print, :birthdays_to_xls], if: :user_signed_in?

  def bills_pays
    if params[:filterrific].present?
      @filterrific_params =  params[:filterrific].permit(["with_category_ids","reset_filterrific", 'with_due_date_gte', 'with_situation_flag', 'with_supplier_ids', "sorted_by", "grouped_by"]).to_h.stringify_keys
    else
      @filterrific_params = nil
    end

       @filterrific = initialize_filterrific(
          BillsPay
          .joins(:supplier, :category)
          .includes(:supplier, :category),
          @filterrific_params,
          select_options: {
            sorted_by: BillsPay.options_for_sorted_by
          },
          default_filter_params: { sorted_by: '' }
        ) or return

       
      @bills_pays = @filterrific.find.page(params[:page]) 

      if params[:filterrific].present? && !params[:filterrific][:grouped_by].blank?        
          if params[:filterrific][:grouped_by] === 'category_id'
            @grouped = @bills_pays.group_by(&:category_id)          
          elsif params[:filterrific][:grouped_by] === 'supplier_id'
            @grouped = @bills_pays.group_by(&:supplier_id)
          end
      else
          @grouped = @bills_pays.group_by(&:category_id)  
      end

      respond_to do |format|
        format.html
        format.js
      end
  end


  def bills_pays_print
    if params[:filterrific].present?
      @filterrific_params =  params[:filterrific].permit(["with_category_ids","reset_filterrific", 'with_due_date_gte', 'with_situation_flag', 'with_supplier_ids', "sorted_by", "grouped_by"]).to_h.stringify_keys
    else
      @filterrific_params = nil
    end

       @filterrific = initialize_filterrific(
          BillsPay
          .joins(:supplier, :category)
          .includes(:supplier, :category),
          @filterrific_params,
          select_options: {
            sorted_by: BillsPay.options_for_sorted_by
          },
          default_filter_params: { sorted_by: '' }
        ) or return

       
      @bills_pays = @filterrific.find.page(params[:page]) 

      if params[:filterrific].present? && !params[:filterrific][:grouped_by].blank?        
          if params[:filterrific][:grouped_by] === 'category_id'
            @grouped = @bills_pays.group_by(&:category_id)          
          elsif params[:filterrific][:grouped_by] === 'supplier_id'
            @grouped = @bills_pays.group_by(&:supplier_id)
          end
      else
          @grouped = @bills_pays.group_by(&:category_id)  
      end

      respond_to do |format|
        format.html { render layout: 'print' }
        format.js
      end
  end

  def bills_receives
    if params[:filterrific].present?
      @filterrific_params =  params[:filterrific].permit(["with_category_ids","reset_filterrific", 'with_due_date_gte', 'with_situation_flag', "sorted_by", "grouped_by"]).to_h.stringify_keys
    else
      @filterrific_params = nil
    end

       @filterrific = initialize_filterrific(
          BillsReceife
          .joins(:people_associated, :category, :financial_account)
          .includes(:people_associated, :category, :financial_account),
          @filterrific_params,
          select_options: {
            sorted_by: BillsReceife.options_for_sorted_by
          },
          default_filter_params: { sorted_by: '' }
        ) or return

       
      @bills_receives = @filterrific.find.page(params[:page]) 

      if params[:filterrific].present? && !params[:filterrific][:grouped_by].blank?        
          if params[:filterrific][:grouped_by] === 'category_id'
            @grouped = @bills_receives.group_by(&:category_id)          
          elsif params[:filterrific][:grouped_by] === 'financial_account_id'
            @grouped = @bills_receives.group_by(&:financial_account_id)
          end
      else
          @grouped = @bills_receives.group_by(&:category_id)  
      end

      respond_to do |format|
        format.html
        format.js
      end
  end

  def bills_receives_print

    if params[:filterrific].present?
      @filterrific_params =  params[:filterrific].permit(["with_category_ids","reset_filterrific", 'with_due_date_gte', 'with_situation_flag', "sorted_by", "grouped_by"]).to_h.stringify_keys
    else
      @filterrific_params = nil
    end

       @filterrific = initialize_filterrific(
          BillsReceife
          .joins(:people_associated, :category, :financial_account)
          .includes(:people_associated, :category, :financial_account),
          @filterrific_params,
          select_options: {
            sorted_by: BillsReceife.options_for_sorted_by
          },
          default_filter_params: { sorted_by: '' }
        ) or return

       
      @bills_receives = @filterrific.find.page(params[:page]) 

      if params[:filterrific].present? && !params[:filterrific][:grouped_by].blank?        
          if params[:filterrific][:grouped_by] === 'category_id'
            @grouped = @bills_receives.group_by(&:category_id)          
          elsif params[:filterrific][:grouped_by] === 'financial_account_id'
            @grouped = @bills_receives.group_by(&:financial_account_id)
          end
      else
          @grouped = @bills_receives.group_by(&:category_id)  
      end

    respond_to do |format|
      format.html { render layout: 'print' }
      format.js
    end
  end

  def birthdays
     if params[:filterrific].present?
        @filterrific_params =  params[:filterrific].permit(["reset_filterrific", 'per_date', "sorted_by", "birthdate_sorted_by"]).to_h.stringify_keys
      else
        @filterrific_params = nil
      end

    @filterrific = initialize_filterrific(
          PeopleAssociated.actives.includes(:workplace, :office),
          @filterrific_params,
          select_options: { birthdate_sorted_by: PeopleAssociated.birthdate_options_for_sorted_by },
          default_filter_params: { birthdate_sorted_by: 'birthdate_asc' }
        ) or return
        
        @birthdays = @filterrific.find if params[:filterrific] && params[:filterrific][:per_date] #.page(params[:page])
  end	

  def birthdays_print
    if params[:filterrific].present?
      @filterrific_params =  params[:filterrific].permit(["reset_filterrific", 'per_date', "sorted_by", "birthdate_sorted_by"]).to_h.stringify_keys
    else
      @filterrific_params = nil
    end


		@filterrific = initialize_filterrific(
          PeopleAssociated.actives.includes(:workplace, :office),
          @filterrific_params,          
          select_options: { birthdate_sorted_by: PeopleAssociated.birthdate_options_for_sorted_by },
          default_filter_params: { birthdate_sorted_by: 'birthdate_asc' }
        ) or return
        
      	@birthdays = @filterrific.find

        respond_to do |format|
          format.html { render layout: 'print' }
          format.js
      end
	end


  def birthdays_to_xls

    @filterrific = initialize_filterrific(
          PeopleAssociated.actives.includes(:workplace, :office),
          params[:filterrific],
          select_options: { birthdate_sorted_by: PeopleAssociated.birthdate_options_for_sorted_by },
          default_filter_params: { birthdate_sorted_by: 'birthdate_asc' }
        ) or return


      @birthdays = @filterrific.find

      to_export = []
      @birthdays.each do |people_associated|
        to_export << {
          "Data de Nascimento": people_associated.birthdate ? I18n.l(people_associated.birthdate, format: :custom_short) : '',
          "Nome": people_associated.name,
          "Logradouro": people_associated.full_address.split(",").reject { |c| c.blank? }.size > 0 ? people_associated.full_address : "",
          "Local de Trabalho": people_associated.workplace.present? ? people_associated.workplace.name : '',
          "Cargo": people_associated.office.present? ? people_associated.office.name : '',
          "Telefone": people_associated.phone,
          "Celular": people_associated.cell_phone1   
        }.compact
      end

      to_export << {"Sem Resultados": ""} if to_export.blank?

      respond_to do |format|
        format.xls { send_data(to_export.to_xls, filename: "Relatorio_Aniversariantes_#{Date.current.strftime("%d_%m_%Y")}.xls") }
      end
  end


def voters
     if params[:filterrific].present?
        @filterrific_params =  params[:filterrific].permit(["reset_filterrific", 'with_workplace_ids', "birthdate_sorted_by"]).to_h.stringify_keys
      else
        @filterrific_params = nil
      end

    @filterrific = initialize_filterrific(
          PeopleAssociated.actives.includes(:workplace, :office),
          params[:filterrific],
          select_options: { birthdate_sorted_by: PeopleAssociated.birthdate_options_for_sorted_by },
          default_filter_params: { birthdate_sorted_by: 'name_asc' }
        ) or return
        
        @birthdays = @filterrific.find  #.page(params[:page])
  end 

  def voters_print
    if params[:filterrific].present?
      @filterrific_params =  params[:filterrific].permit(["reset_filterrific", 'with_workplace_ids', "birthdate_sorted_by"]).to_h.stringify_keys
    else
      @filterrific_params = nil
    end


    @filterrific = initialize_filterrific(
          PeopleAssociated.actives.includes(:workplace, :office),
          @filterrific_params,          
          select_options: { birthdate_sorted_by: PeopleAssociated.birthdate_options_for_sorted_by },
          default_filter_params: { birthdate_sorted_by: 'name_asc' }
        ) or return
        
        @birthdays = @filterrific.find

        respond_to do |format|
          format.html { render layout: 'print' }
          format.js
      end
  end


  def voters_to_xls
    if params[:filterrific].present?
      @filterrific_params =  params[:filterrific].permit(["reset_filterrific", 'with_workplace_ids', "birthdate_sorted_by"]).to_h.stringify_keys
    else
      @filterrific_params = nil
    end

    @filterrific = initialize_filterrific(
          PeopleAssociated.actives.includes(:workplace, :office),
          @filterrific_params,
          select_options: { birthdate_sorted_by: PeopleAssociated.birthdate_options_for_sorted_by },
          default_filter_params: { birthdate_sorted_by: 'name_asc' }
        ) or return


      @birthdays = @filterrific.find

      to_export = []
      @birthdays.each_with_index do |people_associated, index|
        to_export << {
          "ORD": (index + 1),
          "Nome": people_associated.name,
          "Data de filiação": people_associated.affiliate_date ? I18n.l(people_associated.affiliate_date) : '',
          "Local de Trabalho": people_associated.workplace.present? ? people_associated.workplace.name : '',
          "Telefone": people_associated.cell_phone1,
          "Assinatura": ""
        }.compact
      end

      to_export << {"Sem Resultados": ""} if to_export.blank?

      respond_to do |format|
        format.xls { send_data(to_export.to_xls, filename: "Relatorio_Votantes_#{Date.current.strftime("%d_%m_%Y")}.xls") }
      end
  end



  def associateds
      if params[:filterrific].present?
        @filterrific_params =  params[:filterrific].permit(["column_prints", "reset_filterrific", 'with_created_at_gte', 'with_affiliate_date_gte', 'with_affiliate_date_lte', "with_gender_name", 'with_bond_ids', "with_situation_ids", "with_office_ids", "with_occupation_ids", "with_department_ids", "with_workplace_ids", "sorted_by"]).to_h.stringify_keys
      else
        @filterrific_params = nil
      end

    @filterrific = initialize_filterrific(
          PeopleAssociated.includes(:dependents),
          @filterrific_params,
          select_options: {
          sorted_by: PeopleAssociated.options_for_sorted_by
          },
          default_filter_params: { sorted_by: 'hollering_registration_asc' }
        ) or return
        
        @people_associateds = @filterrific.find#.page(params[:page])

      respond_to do |format|
          format.html
          format.js
      end
  end  

  def associateds_print
    if params[:filterrific].present?
       @filterrific_params =  params[:filterrific].permit(["reset_filterrific", 'with_created_at_gte', 'with_affiliate_date_gte', 'with_affiliate_date_lte', "with_gender_name", 'with_bond_ids', "with_situation_ids", "with_office_ids", "with_occupation_ids", "with_department_ids", "with_workplace_ids", "sorted_by"]).to_h.stringify_keys
    else
      @filterrific_params = nil
    end

    @filterrific = initialize_filterrific(
          PeopleAssociated.includes(:dependents),
          @filterrific_params,
          select_options: {
          sorted_by: PeopleAssociated.options_for_sorted_by
          },
          default_filter_params: { sorted_by: 'hollering_registration_asc' }
        ) or return
        
        @people_associateds = @filterrific.find#.page(params[:page])

      respond_to do |format|
          format.html { render layout: 'print' }
          format.js
      end
  end

  def associateds_xml
      if params[:filterrific].present?
        @filterrific_params =  params[:filterrific].permit(["reset_filterrific", 'with_created_at_gte', 'with_affiliate_date_gte', 'with_affiliate_date_lte', "with_gender_name", 'with_bond_ids', "with_situation_ids", "with_office_ids", "with_occupation_ids", "with_department_ids", "with_workplace_ids", "sorted_by"]).to_h.stringify_keys
      else
        @filterrific_params = nil
      end      

      @filterrific = initialize_filterrific(
        PeopleAssociated,
        @filterrific_params,
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
          "Data de filiação": people_associated.affiliate_date.blank? ?  '' : I18n.l(people_associated.affiliate_date),
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
          "Local de Trabalho": people_associated.workplace.present? ? people_associated.workplace.name : '',
          "Departamento": people_associated.office.present? ? people_associated.office.name : '',
          "Matrícula": people_associated.hollering_registration,
          "Secretaria": people_associated.department.present? ? people_associated.department.name : '',
        }.compact
      end

      to_export << {"Sem Resultados": ""} if to_export.blank?

      respond_to do |format|
        format.xls { send_data(to_export.to_xls, filename: "Relatório#{CustomerConfiguration.current.menu_people_associateds}_#{Date.current.strftime("%d_%m_%Y")}.xls") }
      end
  end
	
  def monthly_payments
		@filterrific = initialize_filterrific(
          MonthlyPayment.includes(:people_associated),
          params[:filterrific],
          select_options: {
        	sorted_by: MonthlyPayment.options_for_sorted_by
      	  },
          default_filter_params: { sorted_by: 'due_date_asc' }
        ) or return
        
        @monthly_payments = @filterrific.find#.page(params[:page])

    	respond_to do |format|
      		format.html
      		format.js
    	end
	end

  def business
    @filterrific = initialize_filterrific(
          Company,
          params[:filterrific],
          select_options: {
            sorted_by: Company.options_for_sorted_by
          },
          default_filter_params: { sorted_by: 'created_at_desc' }
        ) or return
        
    @business = @filterrific.find.page(params[:page])
  end

  def stocks
    @filterrific = initialize_filterrific(
          Inventory,
          params[:filterrific],
          select_options: {
            sorted_by: Inventory.options_for_sorted_by
          },
          default_filter_params: { sorted_by: 'created_at_desc' }
        ) or return
        
    @stocks = @filterrific.find.page(params[:page])
  end

  def heritages
     @filterrific = initialize_filterrific(
          Patrimony,
          params[:filterrific],
          select_options: {
            sorted_by: Patrimony.options_for_sorted_by
          },
          default_filter_params: { sorted_by: 'created_at_desc' }
        ) or return
        
    @patrimonies = @filterrific.find.page(params[:page])
  end  

  def dependents
      if params[:filterrific].present?
        @filterrific_params =  params[:filterrific].permit(["reset_filterrific", 'search_query', 'with_active_flag', "sorted_by"]).to_h.stringify_keys
      else
        @filterrific_params = nil
      end

     @filterrific = initialize_filterrific(
          PeopleAssociated.joins(:dependents).includes(:dependents).where("dependents.name != ''"),
          @filterrific_params,
          select_options: {
            sorted_by: Dependent.options_for_sorted_by
          },
          default_filter_params: { sorted_by: 'name_asc' }
        ) or return
          
      @people_associateds = @filterrific.find.page(params[:page])    
  end

  def print_dependents
      if params[:filterrific].present?
        @filterrific_params =  params[:filterrific].permit(["reset_filterrific", 'search_query', 'with_active_flag', "sorted_by"]).to_h.stringify_keys
      else
        @filterrific_params = nil
      end
      
   @filterrific = initialize_filterrific(
        PeopleAssociated.joins(:dependents).includes(:dependents).where("dependents.name != ''"),
        @filterrific_params,
        select_options: {
          sorted_by: Dependent.options_for_sorted_by
        },
        default_filter_params: { sorted_by: 'name_asc' }
      ) or return
        
    @people_associateds = @filterrific.find
    @count_dependents = @people_associateds.collect { |people_associated| people_associated.dependents.count }.sum

    respond_to do |format|
      format.html { render layout: false }
    end
  end

  def calls
    @filterrific = initialize_filterrific(
          AppointbookPeopleassoci.joins(appointment_book: [:professional]).includes(:people_associated, :dependent).references(:people_associated, :dependent),
          params[:filterrific],
          select_options: {
            sorted_by: AppointbookPeopleassoci.options_for_sorted_by
          },
          default_filter_params: { sorted_by: 'start_datetime_desc' }
        ) or return
        
    @calls = @filterrific.find.page(params[:page])


    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "ATENDIMENTOS_#{DateTime.current}",
        margin: {
          top: 5,
          bottom: 30
        }
      end
    end
  end
end
