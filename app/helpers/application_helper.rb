module ApplicationHelper
	def get_current_user_id
		user_signed_in? ? current_user.id : ''
	end
end
