class SpeciesGroup < ActiveRecord::Base
  belongs_to :species
  belongs_to :species_group_state
  belongs_to :group

  validates :species_id, :group_id, presence: true
  validates :species_id, uniqueness: {scope: :group_id,
    message: "Esta especie ya fue sugerida o se encuentra en el grupo"} 

end
