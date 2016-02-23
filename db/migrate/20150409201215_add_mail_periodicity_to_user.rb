class AddMailPeriodicityToUser < ActiveRecord::Migration
  def change
    add_column :users, :mail_periodicity, :integer
  end
end
