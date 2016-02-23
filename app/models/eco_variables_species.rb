class EcoVariablesSpecies < ActiveRecord::Base
	validates_inclusion_of :min, in: 0..1
	validates_inclusion_of :max, in: 0..1
	validates_inclusion_of :mean, in: 0..1
	validates_inclusion_of :certainty, in: 0..1

	def self.search(user_id, species_id)
		where("user_id like ? and species_id = ?", "%#{user_id}%", "#{species_id}")
	end

end