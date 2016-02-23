class AddRegionIdToRegions < ActiveRecord::Migration
  def change
    add_column :regions, :region_id, :integer
    add_index :regions, :name, :unique => true
    add_column :point_comments, :register_id, :string
    add_column :species, :iucn_id, :string
  end
end
