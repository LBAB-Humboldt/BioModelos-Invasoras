class WorkshopTables < ActiveRecord::Migration
  def change

  	create_table :workshops do |t|
  		t.string :name
  		t.boolean :active, :default => false
  		t.text :description
  		t.timestamps
  	end

  	create_table :point_comments do |t|
      t.references :user
      t.references :species
      t.decimal :lat
      t.decimal :lon
      t.boolean :wrong_id, :default => false
      t.boolean :geo_problem, :default => false
      t.text :comment
      t.timestamps
    end

    create_table :workshop_tests do |t|
    	t.references :workshop
    	t.references :user
    	t.references :species
    	t.decimal :lat
    	t.decimal :lon
    	t.float :min_ocurrence
    	t.float :max_ocurrence
    	t.float :best_prob_ocurrence
    	t.float :certainty_true_value
    	t.timestamps
    end
  end
end
