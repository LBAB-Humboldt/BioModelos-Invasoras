class AddFieldsToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :email, :string
    add_column :groups, :link, :string
    add_column :groups, :logo, :string
    add_column :groups, :group_state_id, :integer
  end
end
