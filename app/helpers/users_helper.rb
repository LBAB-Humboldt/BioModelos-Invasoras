module UsersHelper
	def resource_name
    	:user
  	end
 
  	def resource
    	@resource ||= User.find(current_user.id)
  	end
 
  	def devise_mapping
    	@devise_mapping ||= Devise.mappings[:user]
  	end

  	def userCanEdit
  		
  	end
end
