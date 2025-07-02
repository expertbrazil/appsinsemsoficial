class ApplicationController < ActionController::Base
  	protect_from_forgery with: :exception
	before_action :configure_permitted_parameters, if: :devise_controller?
	before_action :check_status

  	layout :layout_by_resource

	def authorize_global(ctrl = params[:controller], action = params[:action], global = true)
	  authorize(ctrl, action, global)
	end

	def authorize(ctrl = params[:controller], action = params[:action], global = true)
	  if current_user.allowed_to?({:controller => ctrl, :action => action}, :global => global)
	    true
	  else
		deny_access
	  end
	end

	def deny_access
	  flash[:error]  = "Você não possui permissão para acessar este recurso"
	  redirect_to '/'
	end

	def after_sign_in_path_for(resource_or_scope)
	  url = stored_location_for(resource_or_scope) || stored_location
	  
	  if url.nil?
	  	url = if resource_or_scope.class == PeopleAssociated 
	  			'/area-associado' 
	  		elsif resource_or_scope.class == Dependent 
	  			'/area-dependente' 
	  		else 
	  			if current_user.present? 
	  				if current_user.active
	  					if current_user.professional
	  						professional_appointment_books_path(current_user.professional) 
	  					else
	  						'/'
	  					end
	  				else
	  					sign_out current_user
	  				end
	  			end
	  		end
	  end

	  url
	end

	def after_sign_out_path_for(resource_or_scope)
	  if resource_or_scope == :dependent
	  	'/acesso-dependente/login'
	  elsif resource_or_scope == :people_associated
        '/acesso-associado/login'
      else
        '/usuarios-do-sistema/sign_in'
      end
	end

	def stored_location
	  session.delete(:return_to)
	end

	def store_location
	  session[:return_to] = request.fullpath
	end  

protected

	def layout_by_resource
		if devise_controller?
			"devise"
		else
			"dashboard"
		end
	end


	def people_associateds_controller?
	  controller_name == "people_associateds"
	end

	def configure_permitted_parameters
		added_attrs = [:login, :username, :email, :password, :password_confirmation, :remember_me]
       	devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit! }
  	end

  	def check_status
  		sign_out current_user if current_user.present? && !current_user.active  			
  	end
end
