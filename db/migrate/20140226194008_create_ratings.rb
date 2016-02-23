class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.references :user
      t.references :model
      t.integer :score, :default => 0
      t.timestamps
    end

    create_table :groups do |t|
    	t.string :name, :null => false
    	t.text :description
    	t.string :img_url
    	t.timestamps
    end

    create_table :groups_users, id: false do |t|
      t.references :group
      t.references :user
      t.timestamps
    end

    add_index :groups_users, [:group_id, :user_id], :unique => true

    create_table :groups_species, :id => false do |t|
    	t.references :group
    	t.references :species
    end

    add_index :groups_species, [:group_id, :species_id], :unique => true

    create_table :activities do |t|
    	t.string :name, :null => false
    	t.text :description
    end

    create_table :activity_users do |t|
    	t.references :user
    	t.references :species
    	t.references :activity
    	t.timestamps
    end

    add_index :activity_users, [:user_id, :species_id]

    add_column :models, :thumb_url, :string    
    add_column :species, :ocurrence_records_url, :string
    add_column :models, :current, :boolean, :default => true

    remove_index :models, :species_id
  	add_index :models, [:species_id, :current]

  end
end
