class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :group_id, :integer
    add_column :users, :requested_group_name, :string
    add_column :users, :last_email_send, :date
  end
end
