module ModelsHelper
	def get_models_name
  		Model.uniq.pluck(:species)    
	end

	def is_integer_num(parameter)
       	!!(parameter =~ /\A[-+]?[0-9]+\z/)
	end
end
