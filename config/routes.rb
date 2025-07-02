Rails.application.routes.draw do
  get 'affiliate_service/appointment_book'
  patch 'atualizar-agenda/(:appointbook_peopleassoci_id)' => 'affiliate_service#update_appointbook_peopleassoci', as: :update_appointbook_peopleassoci

  resources :bills_pays, path: "contas-a-pagar"
  resources :customer_configurations, path: "configuracoes"
  resources :payment_forms, path: "formas-pagamento"
  resources :financial_accounts, path: "contas-contabeis"
  resources :bills_receives, path: "contas-a-receber"
  resources :bank_accounts, path: "bancos"
  resources :categories, path: "plano-contas"
  # resources :subcategories, path: "subcategorias"
  resources :efforts, path: 'autorizacao-empenho'
  resources :type_incorporations, path: 'tipo-de-incorporacoes'
  resources :suppliers, path: 'fornecedores'
  resources :rooms, path: 'salas'
  resources :heritage_groups, path: 'grupo-do-patrimonio'
  # resources :financials, path: 'financas'

  # resources :monthly_payments, path: 'mensalidades' do
  #   match :pay, path: 'pagar',  via: [:get, :patch]
  # end

  resources :workplaces, path: 'locais-de-trabalho'
  resources :segments, path: 'segmentos'
  resources :occupations, path: 'funcoes'
  resources :offices, path: 'cargos'
  resources :patrimonies, path: 'patrimonios'
  resources :departments, path: 'departamentos'
  resources :roles, path: 'regras-de-acesso'
  
  devise_for :users, path: 'usuarios-do-sistema'
  resources :users, path: 'usuários-do-sistema' do
    collection do
      get 'meu-perfil' => 'users#edit_profile'
      post 'meu-perfil' => 'users#update_profile'
    end
  end


  resources :professionals, path: "profissionais"  do 
    resources :appointment_books, path: "agenda" do
      get 'confirma'
      get 'compareceu'
      get 'cancela'
      get 'iniciar-atendimento'
      get 'finalizar-atendimento'
      post 'agendar-retorno'
    end
  end
  
   resources :inventories, path: "estoque" do 
    resources :inventory_movements, path: "movimento-estoque"
   end
   
   resources :companies, path: "empresas-conveniadas"
   
   resources :member_access, path: "area-associado" do 
      collection do
        get 'meu-perfil' => 'member_access#edit_profile'
        post 'meu-perfil' => 'member_access#update_profile'
      end
   end
   
   devise_for :people_associateds, path: 'acesso-associado', 
   path_names: { sign_in: 'login', sign_out: 'logout', session: 'sessao', password: 'recuperar-senha' }, 
   controllers: {
     sessions: 'people_associateds/sessions',
     passwords: 'people_associateds/passwords',
   }   
  
   resources :member_access_dependent, path: "area-dependente" do 
      collection do
        get 'meu-perfil' => 'member_access_dependent#edit_profile'
        post 'meu-perfil' => 'member_access_dependent#update_profile'
      end
   end

   devise_for :dependents, path: 'acesso-dependente', 
   path_names: { sign_in: 'login', sign_out: 'logout', session: 'sessao', password: 'recuperar-senha' }, 
   controllers: {
     sessions: 'dependents/sessions',
     passwords: 'dependents/passwords',
   }

   resources :people_associateds, path: "associados" do
   	resources :dependents, path: "dependentes"
    collection do
      get 'autocomplete'
      get 'search'
      get 'print'
      get 'find_by_cpf'
      get 'load_all'
      get 'my_dependents'
    end  
   end
	
  get 'exportar-associados-em-xls' => 'people_associateds#people_associateds_to_xls', as: :people_associateds_to_xls
  get 'carteirinha/:id' => 'people_associateds#wallet', as: :wallet
  get 'ficha/:id' => 'people_associateds#record', as: :record
  get 'declaracao-uniao-estavel/(:id)' => 'people_associateds#stable_union_statement', as: :stable_union_statement
  get 'declaracao-associado/(:id)' => 'people_associateds#affiliate_statement', as: :affiliate_statement
  get 'desfiliacao-associado/(:id)' => 'people_associateds#affiliate_defiliation', as: :affiliate_defiliation
  get 'declaracao-comprovacao-de-dependente/(:id)' => 'people_associateds#declaration_of_dependency', as: :declaration_of_dependency
  get 'requerimento-desfiliacao/(:id)' => 'people_associateds#affiliation_requirement', as: :affiliation_requirement
  get 'desmarcar-associados-em-analise' => 'people_associateds#clear_all_in_analysis', as: :clear_all_in_analysis

  controller :reports do
    get :birthdays, path: "relatorio-aniversariantes"
    get :birthdays_print, path: "imprimir-relatorio-aniversariantes", as: :birthdays_print
    get :birthdays_to_xls, path: "exportar-relatorio-aniversariantes", as: :birthdays_to_xls
    get :associateds, path: "relatorio-associados"
    get :associateds_print, path: "relatorio-associados-impressao"
    get :associateds_xml, path: 'exportar-associados-em' 
    get :business, path: "relatorio-empresas"
    get :stocks, path: "relatorio-inventarios"
    get :heritages, path: "relatorio-patrimonios"
    get :calls, path: "relatorio-atendimentos"
    get :dependents, path: "relatorio-dependentes"
    get :print_dependents, path: "imprimir-relatorio-dependentes", as: :print_dependents
    get :monthly_payments, path: "relatorio-mensalidades", as: :monthly_payments_report
    get :voters, path: "relatorio-votantes"
    get :voters_print, path: "imprimir-relatorio-votantes", as: :voters_print
    get :voters_to_xls, path: "exportar-relatorio-votantes", as: :voters_to_xls
    get :bills_receives, path: "relatorio-contas-receber", as: :report_bills_receives
    get :bills_receives_print, path: "imprimir-relatorio-contas-receber", as: :bills_receives_print
    get :bills_receives_to_xls, path: "exportar-relatorio-contas-receber", as: :bills_receives_to_xls
    get :bills_pays, path: "relatorio-contas-pagar", as: :report_bills_pays
    get :bills_pays_print, path: "imprimir-relatorio-contas-pagar", as: :bills_pays_print
    get :bills_pays_to_xls, path: "exportar-relatorio-contas-pagar", as: :bills_pays_to_xls
  end

  get 'dashboard' => 'dashboard#index', as: :dashboard
  
  ##### WHATSAPP
  # post 'twilio' => 'dashboard#twilio', as: :twilio
	# post 'twilio_message' => 'dashboard#twilio_message', as: :twilio_message
  ##### SMS
  # post '/twilio/sms'
  #get '/sms/confirma/:token' => 'twilio#confirma', as: :sms_confirma
  post 'comtele/sms'

  match 'site/filiacao' => 'site#inscription',  via: [:get, :post], as: :site_inscription
  match 'site/bem-vindos' => 'site#welcome',  via: [:get], as: :site_welcome
  
	root :to => "dashboard#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
