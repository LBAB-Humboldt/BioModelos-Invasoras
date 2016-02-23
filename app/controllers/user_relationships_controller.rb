class UserRelationshipsController < ApplicationController

  # Crea o Elimina la relación entre usuarios
  def create
    relationship_params=params[:user_relationship]
    user_relationship = UserRelationship.find_by_user_id_and_follower_id(relationship_params[:user_id], current_user.id)
    if user_relationship
      if user_relationship.delete
        redirect_to user_path(id:relationship_params[:user_id])
      end
    else
      @relationship = UserRelationship.new
      @relationship.user_id=relationship_params[:user_id]
      @relationship.follower_id=current_user.id
      if @relationship.save
        redirect_to user_path(id:relationship_params[:user_id])
      end
    end
  end
end
