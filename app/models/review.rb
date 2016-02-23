class Review < ActiveRecord::Base

	validates :user_id, :presence => true
	validates :model_id, :presence => true
	validates :geoJSON, :presence => true, 
						length: { minimum: 2, maximum: 1999999, too_long: "La anotación supera el tamaño máximo permitido." }

	belongs_to :user
	belongs_to :model

	#************************ FRANK CODE *******************
	def self.search(id)
 		find_by_sql("
			SELECT 
				reviews.id, species.sci_name, species.family, reviews.geoJSON, reviews.user_id
			FROM 
				reviews 
				JOIN models ON models.id = reviews.model_id
				JOIN species ON species.id = models.species_id
			WHERE 
				species.`id` = #{id} 
				AND species.`current` = 't'
			ORDER BY 
				reviews.id DESC
		")
	end		
	#************************ END FRANK CODE *******************

end
