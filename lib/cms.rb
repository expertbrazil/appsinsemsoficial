# -*- encoding : utf-8 -*-
require 'cms/access_control'

Cms::AccessControl.map do |map|

  map.project_module :modules do |map|
    map.permission :module_roles, :read => true
    map.permission :module_companies, :read => true
    map.permission :module_users, :read => true
    map.permission :module_dependents, :read => true
    map.permission :module_appointment_books, :read => true
    map.permission :module_inventories, :read => true
    map.permission :module_people_associateds, :read => true
    map.permission :module_professionals, :read => true
    map.permission :module_patrimonies, :read => true
    # map.permission :module_heritage_groups, :read => true
    # map.permission :module_rooms, :read => true
    # map.permission :module_suppliers, :read => true
    map.permission :module_departments, :read => true
    map.permission :module_reports, :read => true
    map.permission :module_offices, :read => true
    map.permission :module_occupations, :read => true
    map.permission :module_segments, :read => true
    map.permission :module_workplaces, :read => true
    map.permission :module_financials, :read => true
    map.permission :module_bank_accounts, :read => true
    map.permission :module_categories, :read => true
    map.permission :module_subcategories, :read => true
    map.permission :module_customer_configurations, :read => true
  end
  
  map.project_module :customer_configurations do |map|
    map.permission :manager_customer_configurations, {:customer_configurations => [:index, :new, :edit, :create, :update, :destroy, :show]}, :read => true
    map.permission :create_customer_configurations, {:customer_configurations => [:index, :new, :create]}, :read => true
    map.permission :edit_customer_configurations, {:customer_configurations => [:index, :edit, :update]}, :read => true
    map.permission :destroy_customer_configurations, {:customer_configurations => [:index, :destroy]}, :read => true
    map.permission :list_customer_configurations, {:customer_configurations => [:index]}, :read => true
  end  

  map.project_module :financials do |map|
    map.permission :manager_financials, {:financials => [:index]}, :read => true
    
    # # map.permission :manager_monthly_payments, {:monthly_payments => [:index, :new, :edit, :create, :update, :destroy, :show, :pay]}, :read => true
    # map.permission :create_monthly_payments, {:monthly_payments => [:index, :new, :create]}, :read => true
    # map.permission :edit_monthly_payments, {:monthly_payments => [:index, :edit, :update]}, :read => true
    # map.permission :destroy_monthly_payments, {:monthly_payments => [:index, :destroy]}, :read => true
    # map.permission :list_monthly_payments, {:monthly_payments => [:index]}, :read => true
  end   
  
  map.project_module :bank_accounts do |map|
    map.permission :manager_bank_accounts, {:bank_accounts => [:index, :new, :edit, :create, :update, :destroy, :show]}, :read => true
    map.permission :create_bank_accounts, {:bank_accounts => [:index, :new, :create]}, :read => true
    map.permission :edit_bank_accounts, {:bank_accounts => [:index, :edit, :update]}, :read => true
    map.permission :destroy_bank_accounts, {:bank_accounts => [:index, :destroy]}, :read => true
    map.permission :list_bank_accounts, {:bank_accounts => [:index]}, :read => true
    map.permission :show_bank_accounts, {:bank_accounts => [:index, :show]}, :read => true
  end

  map.project_module :categories do |map|
    map.permission :manager_categories, {:categories => [:index, :new, :edit, :create, :update, :destroy, :show]}, :read => true
    map.permission :create_categories, {:categories => [:index, :new, :create]}, :read => true
    map.permission :edit_categories, {:categories => [:index, :edit, :update]}, :read => true
    map.permission :destroy_categories, {:categories => [:index, :destroy]}, :read => true
    map.permission :list_categories, {:categories => [:index]}, :read => true
  end  

  map.project_module :subcategories do |map|
    map.permission :manager_subcategories, {:subcategories => [:index, :new, :edit, :create, :update, :destroy, :show]}, :read => true
    map.permission :create_subcategories, {:subcategories => [:index, :new, :create]}, :read => true
    map.permission :edit_subcategories, {:subcategories => [:index, :edit, :update]}, :read => true
    map.permission :destroy_subcategories, {:subcategories => [:index, :destroy]}, :read => true
    map.permission :list_subcategories, {:subcategories => [:index]}, :read => true
  end

  map.project_module :module_reports do |map|
    map.permission :birthdays, {:reports => [:birthdays]}, :read => true    
    map.permission :associateds, {:reports => [:associateds]}, :read => true    
    map.permission :business, {:reports => [:business]}, :read => true    
    map.permission :stocks, {:reports => [:stocks]}, :read => true    
    map.permission :heritages, {:reports => [:heritages]}, :read => true    
    map.permission :calls, {:reports => [:calls]}, :read => true    
    map.permission :dependents, {:reports => [:dependents]}, :read => true    
    map.permission :monthly_payments, {:reports => [:monthly_payments]}, :read => true    
    map.permission :voters, {:reports => [:voters, :voters_print, :voters_to_xls]}, :read => true    
    map.permission :bills_receives, {:reports => [:bills_receives, :bills_receives_print, :bills_receives_to_xls]}, :read => true    
    map.permission :bills_pays, {:reports => [:bills_pays, :bills_pays_print, :bills_pays_to_xls]}, :read => true    
  end

  map.project_module :workplaces do |map|
    map.permission :manager_workplaces, {:workplaces => [:index, :new, :edit, :create, :update, :destroy, :show]}, :read => true
    map.permission :create_workplaces, {:workplaces => [:index, :new, :create]}, :read => true
    map.permission :edit_workplaces, {:workplaces => [:index, :edit, :update]}, :read => true
    map.permission :destroy_workplaces, {:workplaces => [:index, :destroy]}, :read => true
    #map.permission :show_workplaces, {:workplaces => [:index, :show]}, :read => true
    map.permission :list_workplaces, {:workplaces => [:index]}, :read => true
  end     

  map.project_module :segments do |map|
    map.permission :manager_segments, {:segments => [:index, :new, :edit, :create, :update, :destroy, :show]}, :read => true
    map.permission :create_segments, {:segments => [:index, :new, :create]}, :read => true
    map.permission :edit_segments, {:segments => [:index, :edit, :update]}, :read => true
    map.permission :destroy_segments, {:segments => [:index, :destroy]}, :read => true
    #map.permission :show_segments, {:segments => [:index, :show]}, :read => true
    map.permission :list_segments, {:segments => [:index]}, :read => true
  end   

  map.project_module :occupations do |map|
    map.permission :manager_occupations, {:occupations => [:index, :new, :edit, :create, :update, :destroy, :show]}, :read => true
    map.permission :create_occupations, {:occupations => [:index, :new, :create]}, :read => true
    map.permission :edit_occupations, {:occupations => [:index, :edit, :update]}, :read => true
    map.permission :destroy_occupations, {:occupations => [:index, :destroy]}, :read => true
    #map.permission :show_occupations, {:occupations => [:index, :show]}, :read => true
    map.permission :list_occupations, {:occupations => [:index]}, :read => true
  end   

  map.project_module :offices do |map|
    map.permission :manager_offices, {:offices => [:index, :new, :edit, :create, :update, :destroy, :show]}, :read => true
    map.permission :create_offices, {:offices => [:index, :new, :create]}, :read => true
    map.permission :edit_offices, {:offices => [:index, :edit, :update]}, :read => true
    map.permission :destroy_offices, {:offices => [:index, :destroy]}, :read => true
    #map.permission :show_offices, {:offices => [:index, :show]}, :read => true
    map.permission :list_offices, {:offices => [:index]}, :read => true
  end 

  map.project_module :departments do |map|
    map.permission :manager_departments, {:departments => [:index, :new, :edit, :create, :update, :destroy, :show]}, :read => true
    map.permission :create_departments, {:departments => [:index, :new, :create]}, :read => true
    map.permission :edit_departments, {:departments => [:index, :edit, :update]}, :read => true
    map.permission :destroy_departments, {:departments => [:index, :destroy]}, :read => true
    #map.permission :show_departments, {:departments => [:index, :show]}, :read => true
    map.permission :list_departments, {:departments => [:index]}, :read => true
  end 

  map.project_module :patrimonies do |map|
    map.permission :manager_patrimonies, {
      :patrimonies => [:index, :new, :edit, :create, :update, :destroy, :show],
      :heritage_groups => [:index, :new, :edit, :create, :update, :destroy, :show],
      :rooms => [:index, :new, :edit, :create, :update, :destroy, :show],
      :type_incorporations => [:index, :new, :edit, :create, :update, :destroy, :show],
      :suppliers => [:index, :new, :edit, :create, :update, :destroy, :show]
    }, :read => true
    map.permission :create_patrimonies, {
      :patrimonies => [:index, :new, :create],
      :heritage_groups => [:index, :new, :create],
      :rooms => [:index, :new, :create],
      :type_incorporations => [:index, :new, :create],
      :suppliers => [:index, :new, :create],
    }, :read => true
    map.permission :edit_patrimonies, {
      :patrimonies => [:index, :edit, :update],
      :heritage_groups => [:index, :edit, :update],
      :rooms => [:index, :edit, :update],
      :type_incorporations => [:index, :edit, :update],
      :suppliers => [:index, :edit, :update],
    }, :read => true
    map.permission :destroy_patrimonies, {
      :patrimonies => [:index, :destroy],
      :heritage_groups => [:index, :destroy],
      :rooms => [:index, :destroy],
      :type_incorporations => [:index, :destroy],
      :suppliers => [:index, :destroy],
    }, :read => true
    map.permission :list_patrimonies, {
      :patrimonies => [:index],
      :heritage_groups => [:index],
      :rooms => [:index],
      :type_incorporations => [:index],
      :suppliers => [:index],
    }, :read => true
  end  

  # map.project_module :heritage_groups do |map|
  #   map.permission :create_heritage_groups, {}, :read => true
  #   map.permission :edit_heritage_groups, {}, :read => true
  #   map.permission :destroy_heritage_groups, {:heritage_groups => [:index, :destroy]}, :read => true
  #   #map.permission :show_heritage_groups, {:heritage_groups => [:index, :show]}, :read => true
  #   map.permission :list_heritage_groups, {:heritage_groups => [:index]}, :read => true
  # end  

  # map.project_module :rooms do |map|
  #   map.permission :create_rooms, {:rooms => [:index, :new, :create]}, :read => true
  #   map.permission :edit_rooms, {:rooms => [:index, :edit, :update]}, :read => true
  #   map.permission :destroy_rooms, {:rooms => [:index, :destroy]}, :read => true
  #   #map.permission :show_rooms, {:rooms => [:index, :show]}, :read => true
  #   map.permission :list_rooms, {:rooms => [:index]}, :read => true
  # end  

  # map.project_module :suppliers do |map|
  #   map.permission :manager_suppliers, {:suppliers => [:index, :new, :edit, :create, :update, :destroy, :show]}, :read => true
  #   map.permission :create_suppliers, {:suppliers => [:index, :new, :create]}, :read => true
  #   map.permission :edit_suppliers, {:suppliers => [:index, :edit, :update]}, :read => true
  #   map.permission :destroy_suppliers, {:suppliers => [:index, :destroy]}, :read => true
  #   #map.permission :show_suppliers, {:suppliers => [:index, :show]}, :read => true
  #   map.permission :list_suppliers, {:suppliers => [:index]}, :read => true
  # end

  map.project_module :roles do |map|
    map.permission :manager_roles, {:roles => [:index, :new, :edit, :create, :update, :destroy, :show]}, :read => true
    map.permission :create_roles, {:roles => [:index, :new, :create]}, :read => true
    map.permission :edit_roles, {:roles => [:index, :edit, :update]}, :read => true
    map.permission :destroy_roles, {:roles => [:index, :destroy]}, :read => true
    #map.permission :show_roles, {:roles => [:index, :show]}, :read => true
    map.permission :list_roles, {:roles => [:index]}, :read => true
  end

  map.project_module :companies do |map|
    map.permission :manager_companies, {:companies => [:index, :new, :edit, :create, :update, :destroy, :show]}, :read => true
    map.permission :create_companies, {:companies => [:index, :new, :create]}, :read => true
    map.permission :edit_companies, {:companies => [:index, :edit, :update]}, :read => true
    map.permission :destroy_companies, {:companies => [:index, :destroy]}, :read => true
    #map.permission :show_companies, {:companies => [:index, :show]}, :read => true
    map.permission :list_companies, {:companies => [:index]}, :read => true
  end

  map.project_module :dependents do |map|
    map.permission :manager_dependents, {:dependents => [:index, :new, :edit, :create, :update, :destroy, :show]}, :read => true
    map.permission :create_dependents, {:dependents => [:index, :new, :create]}, :read => true
    map.permission :edit_dependents, {:dependents => [:index, :edit, :update]}, :read => true
    map.permission :destroy_dependents, {:dependents => [:index, :destroy]}, :read => true
    #map.permission :show_dependents, {:dependents => [:index, :show]}, :read => true
    map.permission :list_dependents, {:dependents => [:index]}, :read => true
  end

  map.project_module :inventories do |map|
    map.permission :manager_inventories, {:inventories => [:index, :new, :edit, :create, :update, :destroy, :show]}, :read => true
    map.permission :create_inventories, {:inventories => [:index, :new, :create]}, :read => true
    map.permission :edit_inventories, {:inventories => [:index, :edit, :update]}, :read => true
    map.permission :destroy_inventories, {:inventories => [:index, :destroy]}, :read => true
    #map.permission :show_inventories, {:inventories => [:index, :show]}, :read => true
    map.permission :list_inventories, {:inventories => [:index]}, :read => true
  end

  map.project_module :inventory_movements do |map|
    map.permission :manager_inventory_movements, {:inventory_movements => [:index, :new, :edit, :create, :update, :destroy, :show]}, :read => true
    map.permission :create_inventory_movements, {:inventory_movements => [:index, :new, :create]}, :read => true
    map.permission :edit_inventory_movements, {:inventory_movements => [:index, :edit, :update]}, :read => true
    map.permission :destroy_inventory_movements, {:inventory_movements => [:index, :destroy]}, :read => true
    #map.permission :show_inventory_movements, {:inventory_movements => [:index, :show]}, :read => true
    map.permission :list_inventory_movements, {:inventory_movements => [:index]}, :read => true
  end

  map.project_module :people_associateds do |map|
    map.permission :manager_people_associateds, {:people_associateds => [:index, :new, :edit, :create, :update, :destroy, :show, :people_associateds_to_xls]}, :read => true
    map.permission :create_people_associateds, {:people_associateds => [:index, :new, :create, :people_associateds_to_xls]}, :read => true
    map.permission :edit_people_associateds, {:people_associateds => [:index, :edit, :update, :people_associateds_to_xls]}, :read => true
    map.permission :destroy_people_associateds, {:people_associateds => [:index, :destroy, :people_associateds_to_xls]}, :read => true
    #map.permission :show_people_associateds, {:people_associateds => [:index, :show]}, :read => true
    map.permission :list_people_associateds, {:people_associateds => [:index, :people_associateds_to_xls]}, :read => true
  end

  map.project_module :users do |map|
    map.permission :manager_users, {:users => [:index, :new, :edit, :create, :update, :destroy, :show]}, :read => true
    map.permission :create_users, {:users => [:index, :new, :create]}, :read => true
    map.permission :edit_users, {:users => [:index, :edit, :update]}, :read => true
    map.permission :destroy_users, {:users => [:index, :destroy]}, :read => true
    #map.permission :show_users, {:users => [:index, :show]}, :read => true
    map.permission :list_users, {:users => [:index]}, :read => true
  end

  map.project_module :appointment_books do |map|
    map.permission :manager_appointment_books, {:appointment_books => [:index, :new, :edit, :create, :update, :destroy, :show]}, :read => true
    map.permission :create_appointment_books, {:appointment_books => [:index, :new, :create]}, :read => true
    map.permission :edit_appointment_books, {:appointment_books => [:index, :edit, :update]}, :read => true
    map.permission :destroy_appointment_books, {:appointment_books => [:index, :destroy]}, :read => true
    #map.permission :show_appointment_books, {:appointment_books => [:index, :show]}, :read => true
    map.permission :list_appointment_books, {:appointment_books => [:index]}, :read => true
  end 

  map.project_module :professionals do |map|
    map.permission :manager_professionals, {:professionals => [:index, :new, :edit, :create, :update, :destroy, :show]}, :read => true
    map.permission :create_professionals, {:professionals => [:index, :new, :create]}, :read => true
    map.permission :edit_professionals, {:professionals => [:index, :edit, :update]}, :read => true
    map.permission :destroy_professionals, {:professionals => [:index, :destroy]}, :read => true
    #map.permission :show_professionals, {:professionals => [:index, :show]}, :read => true
    map.permission :list_professionals, {:professionals => [:index]}, :read => true
  end

end
