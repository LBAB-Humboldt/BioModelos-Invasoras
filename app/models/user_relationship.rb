class UserRelationship < ActiveRecord::Base
  belongs_to :user
  belongs_to :user, :foreign_key => :follower_id
end
