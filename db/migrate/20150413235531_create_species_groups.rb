class CreateSpeciesGroups < ActiveRecord::Migration
  def change
    create_table :species_groups do |t|
      t.integer :species_id
      t.integer :group_id
      t.integer :species_group_state_id

      t.timestamps null: false
    end
  end
end
