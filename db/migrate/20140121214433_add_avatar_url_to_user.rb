class AddAvatarUrlToUser < ActiveRecord::Migration
  def change
  	add_column :users, :avatarUrl, :string
  	add_column :users, :interestGroups, :string
  end
end
