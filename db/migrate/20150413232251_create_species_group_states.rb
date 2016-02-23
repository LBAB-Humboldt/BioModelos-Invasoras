class CreateSpeciesGroupStates < ActiveRecord::Migration
  def change
    create_table :species_group_states do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
