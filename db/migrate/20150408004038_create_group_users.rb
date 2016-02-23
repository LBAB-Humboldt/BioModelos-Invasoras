class CreateGroupUsers < ActiveRecord::Migration
  def change
    create_table :group_users do |t|
      t.integer :group_id
      t.integer :user_id
      t.boolean :is_admin
      t.integer :group_user_state_id

      t.timestamps
    end
  end
end
