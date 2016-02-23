class AddCurrentToSpecies < ActiveRecord::Migration
  def change
  	add_column :species, :current, :boolean, default: 't'
  end
end
