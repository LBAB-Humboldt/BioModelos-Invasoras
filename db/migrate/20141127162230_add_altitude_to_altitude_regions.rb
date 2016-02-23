class AddAltitudeToAltitudeRegions < ActiveRecord::Migration
  def change
  	rename_column :altitude_ranges, :altitude, :alt_min
  	change_column :altitude_ranges, :alt_min, :integer, default: 0
  	add_column :altitude_ranges, :alt_max, :integer, default: 0
  end
end
