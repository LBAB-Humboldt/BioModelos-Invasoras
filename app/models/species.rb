class Species < ActiveRecord::Base
	
	has_many :models
	has_and_belongs_to_many :groups
	has_many :species_groups
	has_and_belongs_to_many :categories
	acts_as_commentable

#	def self.search(options)
#		if options[:query] and options[:class_id]
#      		where("sci_name like ? and class_id = ? and current = ?", "%#{options[:query]}%", "#{options[:class_id]}", "t").limit(10)
#    	elsif options[:query]
#      		where("sci_name like ? and current = ?", "%#{options[:query]}%", "t").limit(10)
#    	end
#	end

	#************** FRANK CODE ***********************
	def self.search(options)
		if options[:query] != ""
			query = "AND s.`sci_name` LIKE '%#{options[:query]}%'"
		end 
      	if options[:class_id] != ""
      		classId = "AND S.`class_id` =#{options[:class_id]}"
		end 
    	if options[:category] != ""
      		category = "AND C.`categories_id` IN(#{options[:category]})"
      		join = "JOIN categories_species C ON S.`id` = C.`species_id`"
    	end

		find_by_sql("
			SELECT 
				--S.`id`,S.`sci_name`
				S.*
			FROM
				species S
				#{join}
			WHERE 
				S.`current` = 't'
				#{query}
				#{classId}
				#{category}
			ORDER BY
				S.`sci_name`
			LIMIT 10
		")

	end
	#************** END FRANK CODE ***********************

	#************** FRANK CODE ***********************
	def self.searchAdv(classId, from, to, altitudfrom, altitudto, localidad, tiporeg, fuente, institucion)
      	if !from.blank? && !to.blank? 
			from = "AND M.model_date BETWEEN '#{from}' AND '#{to}'" 
		end
		if !from.blank? && to.blank?
			from = "AND M.model_date >= '#{from}'" 
		end
		if from.blank? && !to.blank?
			from = "AND reviews.geoJSON <= '#{to}'"
		end
		if !from.blank? && !to.blank?
			from = "" 
		end


      	if !altitudfrom.blank? && !altitudto.blank? 
			altitud = "AND reviews.geoJSON LIKE '%\"Altura\": \"#{altitud}%'" 
		end
		if !altitudfrom.blank? && altitudto.blank?
			altitud = "AND reviews.geoJSON LIKE '%\"Altura\": \"#{altitud}%'" 
		end
		if altitudfrom.blank? && !altitudto.blank?
			altitud = "AND reviews.geoJSON LIKE '%\"Altura\": \"#{altitud}%'" 
		end
		if !altitudfrom.blank? && !altitudto.blank?
			altitud = "" 
		end


      	if !localidad.blank?
			localidad = "AND reviews.geoJSON LIKE '%\"Localidad\": \"#{localidad}%'" 
		end
      	if !tiporeg.blank?
			tiporeg = "AND reviews.geoJSON LIKE '%\"Tipo\": \"#{tiporeg}%'" 
		end

      	if !fuente.blank?
			fuente = "AND reviews.geoJSON LIKE '%\"Fuente\": \"#{fuente}%'" 
		end
      	if !institucion.blank?
			institucion = "AND reviews.geoJSON LIKE '%\"Institucion\": \"#{institucion}%'" 
		end


		find_by_sql("
			SELECT 
				reviews.id, species.sci_name, species.family, reviews.geoJSON, reviews.user_id
			FROM 
				species
				LEFT JOIN user_species_regions AS US ON US.species_id = species.id
				LEFT JOIN regions R ON R.id = US.region_id
				LEFT JOIN models M ON M.species_id = species.id
				LEFT JOIN altitude_ranges A ON A.species_id = species.id
				JOIN reviews ON reviews.model_id = M.id
			WHERE
				1 = 1
				AND species.`class_id` = #{classId} 
				AND species.`current` = 't'
				#{from} 
				#{altitud} 
				#{localidad} 
				#{tiporeg} 
				#{fuente} 
				#{institucion} 
			--GROUP BY
			--	R.id, species.id
			ORDER BY
				R.name, species.sci_name
		")
	end	
	#************** END FRANK CODE *******************

end
