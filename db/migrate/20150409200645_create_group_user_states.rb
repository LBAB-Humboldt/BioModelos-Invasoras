class CreateGroupUserStates < ActiveRecord::Migration
  def change
    create_table :group_user_states do |t|
      t.string :name

      t.timestamps
    end
  end
end
