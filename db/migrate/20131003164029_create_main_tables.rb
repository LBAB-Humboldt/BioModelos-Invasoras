class CreateMainTables < ActiveRecord::Migration
  def change
    create_table :users do |t|

    	t.string :name
    	t.string :role
    	t.string :location
        t.string :organization
    	t.text :bio

    	t.timestamps
    end

    create_table :classes do |t|
        t.string :class_name
        t.timestamps
    end

    create_table :species do |t|
        t.references :class
        t.string :sci_name
        t.string :order
        t.string :family
        t.string :sib_url
        t.integer :ocurrence_records
        t.timestamps
    end

    add_index :species, :class_id
    add_index :species, :sci_name, :unique => true

    create_table :models do |t|

    	t.references :species
    	t.string :img_url
    	t.date :model_date
    	t.string :author
    	t.text :description
    	t.integer :rating, :default => 0
        t.boolean :validated, :default => false 

    	t.timestamps

    end

    add_index :models, :species_id

    create_table :reviews do |t|

    	t.references :user
    	t.references :model
    	t.text :geoJSON, :limit => 2.megabytes
    	t.timestamps
    end

    add_index :reviews, :user_id
    add_index :reviews, :model_id

    create_table :comments do |t|

    	t.string :title
	    t.string :body
	    t.integer :commentable_id
	    t.string :commentable_type

    	t.timestamps
    end

    add_index :comments, [:commentable_id, :commentable_type]

    end

end
