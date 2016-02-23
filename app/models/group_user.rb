class GroupUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  belongs_to :group_user_state

  validates :user_id, uniqueness: {scope: :group_id,
    message: "Este usuario ya aplicó o se encuentra en el grupo"} 

end
