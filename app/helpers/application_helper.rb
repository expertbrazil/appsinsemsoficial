module ApplicationHelper
	def edit_mode?
		true if (controller.action_name == "edit" || controller.action_name == "update")
	end

	def is_active?(target)
		'active' if controller.controller_name == target.to_s
	end

	def is_active_action?(target_act)
		'active' if controller.action_name == target_act.to_s
	end

	def class_active?(names)
		names.include?(controller.controller_name) ? 'active' : ''
	end
	
	def class_toggled?(names)
		names.include?(controller.controller_name) ? 'toggled' : ''
	end


	def preloader
		raw %{ 
				<div class="preloader pl-lg">
        			<svg class="pl-circular" viewBox="25 25 50 50">
            			<circle class="plc-path" cx="50" cy="50" r="20"></circle>
        			</svg>
    			</div>
    		}
	end

	def loading_full
		raw %{
			<div class="page-loader" style="display: block;">
	            <div class="preloader pls-blue">
	                <svg class="pl-circular" viewBox="25 25 50 50">
	                    <circle class="plc-path" cx="50" cy="50" r="20"></circle>
	                </svg>

	                <p>Carregando...</p>
	            </div>
	        </div>
		}
	end


	def bootstrap_class_for flash_type
		case flash_type
		    when 'success'
		      "alert-success" # Green
		    when 'error'
		      "alert-danger" # Red
		    when 'alert'
		      "alert-warning" # Yellow
		    when 'notice'
		      "alert-success" # Blue
		    else
		      flash_type.to_s
		end
	end

	def flash_messages(opts = {})
	    flash.each do |msg_type, message|
	      	concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do
	            concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
	            concat message
	        end)
	    end
	 nil
	end

	def errors(object)
	    output = ""
	    if object.errors.any? 
	      object.errors.full_messages.each do |msg| 
	        output << "#{msg} <br />"
	      end
	    end   	

	    raw bootstrap_message({ :error => output })
	end

	def bootstrap_message(flash)
	    output = ""
	    
	    flash.each do |ftype, message|
	      msg_class = bootstrap_class_for ftype.to_s
	      output << content_tag(:div, message, class: "alert #{msg_class} fade in") do
	            concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
	            concat raw(message)
	        end
	    end
	    
	    output
	  end


	    # Creates a link tag with the given +title+ to the given +url+. Works like link_to,
  # but takes an additional :icon option.
  #
  # ==== Examples
  #   icon_link_to("Example", "http://www.example.com", icon: "icon-comment")
  #   # => <a href="http://www.example.com" class="btn"><i class="icon-comment"></i> Title</a>
  def icon_link_to(title, url, options = {})
    link_to(iconize(title, options[:icon]), url, options.merge(icon: nil))
  end

  # Adds icon to a given text
  #
  # ==== Examples
  #   iconize("Example", icon: "icon-comment")
  #   # => <i class="icon-comment"></i> Title
  def iconize(text, icon = nil)
    if icon.to_s.empty?
      text
    else
      icon_for(icon) + " " + text
    end
  end

  # Returns <i class="your-icon"></i>
  #
  # === Examples
  #   icon_for("icon-comment")
  #   # => <i class="icon-comment"></i>
  def icon_for(icon)
    content_tag(:i, nil, class: icon.to_s)
  end


  	def search_chart_of_account(f)
		%Q(	<div class='form-group'>
					#{f.label :category_id, 'Plano de contas'}
					#{f.hidden_field :category_id }
					<div class='input-group'>
						<input type="text" name="" value="#{f.object.category.present? ? f.object.category.name : ''}" id="chart_of_account_name" class="form-control disabled" disabled="true" placeholder="Busque o plano de contas">

						<div class="input-group-addon hand" style="cursor:pointer;" data-toggle="modal" data-target="#search_chart_of_account">
							<i class="zmdi zmdi-search"></i>
						</div>
					</div>

					#{render 'categories/modal_search', f: f }

					<script type="text/javascript">
					  function select_chart_of_account(id, name){
					    $("##{f.object.class.model_name.param_key}_category_id").val(id);
					    $("#chart_of_account_name").val(name);

					    $("#search_chart_of_account").modal('hide');
					  }
					</script>
		</div>).html_safe
	end

	# def nested_dropdown(adcategories)
	# 	result = []
	# 	adcategories.map do |adcategory, sub_adcategories|
	# 		if adcategory.depth == 0
	#     		result << [('|_' * (adcategory.depth + 1)) + adcategory.name.mb_chars.upcase, adcategory.id]
	#     	else
	#     		result << [('|_' +('_' * (adcategory.depth + 1))) + adcategory.name.mb_chars.upcase, adcategory.id]
	#     	end
	#     	result += nested_dropdown(sub_adcategories) unless sub_adcategories.blank?
	# 	end
	# 	result
	# end

	def subcat_prefix(depth)
	  ("&nbsp;" * 4 * depth).html_safe
	 end

	 def debit_categories_options_array(current_id = 0,categories=[], parent_id=0, depth=0)
	 	if parent_id == 0
	 		Category.select_options_grouped_by_dedit_categories.each do |category, data|
		      categories << [subcat_prefix(depth) + category.name.mb_chars.upcase, category.id]
		      debit_categories_options_array(current_id,categories, category.id, depth+1)
		  end
	 	else
		  Category.where('parent_id = ? AND id != ?', parent_id, current_id ).order(:id).each do |category|
		      categories << [subcat_prefix(depth) + category.name.mb_chars.upcase, category.id]
		      debit_categories_options_array(current_id,categories, category.id, depth+1)
		  end
		end

	  categories
	end

	def credit_categories_options_array(current_id = 0,categories=[], parent_id=0, depth=0)
	 	if parent_id == 0
	 		Category.select_options_grouped_by_credit_categories.each do |category, data|
		      categories << [subcat_prefix(depth) + category.name.mb_chars.upcase, category.id]
		      credit_categories_options_array(current_id,categories, category.id, depth+1)
		  end
	 	else
		  Category.where('parent_id = ? AND id != ?', parent_id, current_id ).order(:id).each do |category|
		      categories << [subcat_prefix(depth) + category.name.mb_chars.upcase, category.id]
		      credit_categories_options_array(current_id,categories, category.id, depth+1)
		  end
		end

	  categories
	end

end
