class AddTableAltitudeRange < ActiveRecord::Migration
  def change
  	create_table :altitude_ranges do |t|
    	t.references :user
    	t.references :species
    	t.integer	 :altitude
    	t.timestamps
    end
  end
end
