class EcologicalVariables < ActiveRecord::Migration

  if ActiveRecord::Base.connection.table_exists? 'workshop_tests'
      drop_table :workshop_tests
  end

  if ActiveRecord::Base.connection.table_exists? 'workshops'
      drop_table :workshops
  end

  def change
  	create_table :eco_variables do |t|
  		t.string :variable
    	t.timestamps
    end

    create_table :eco_variables_species do |t|
		t.references :user
		t.references :species
		t.references :eco_variable
		t.float :min, :default => 0
    	t.float :max, :default => 0
    	t.float :mean, :default => 0
    	t.float :certainty, :default => 0
    	t.timestamps
	end

	add_column :models, :level, :integer, :default => 1 

  end
end
