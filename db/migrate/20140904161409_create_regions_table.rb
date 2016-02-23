class CreateRegionsTable < ActiveRecord::Migration
  def change
    create_table :regions do |t|
    	t.string :name
    	t.timestamps
    end

    create_table :user_species_regions do |t|
    	t.references :user
    	t.references :region
    	t.references :species
    	t.timestamps
    end
  end
end
