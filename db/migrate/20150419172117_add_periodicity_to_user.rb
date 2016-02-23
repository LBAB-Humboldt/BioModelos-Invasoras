class AddPeriodicityToUser < ActiveRecord::Migration
  def change
    add_column :users, :periodicity_id, :integer
  end
end
