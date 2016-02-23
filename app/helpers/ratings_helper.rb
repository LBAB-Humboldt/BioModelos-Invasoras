module RatingsHelper
	def rating_exists(mid, lvl)
		
		@models = Model.where(:species_id => Model.find(params[:mid]).species_id, :level => params[:lvl])

		@alreadyRated = false
		@models.each do |m|
			if Rating.rating_exists(:model_id => m.id, :user_id => current_user.id) && m.id != params[:mid]
				@alreadyRated = true
				break
			end
		end

		return @alreadyRated

	end
end
