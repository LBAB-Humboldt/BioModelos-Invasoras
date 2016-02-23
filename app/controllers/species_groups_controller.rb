class SpeciesGroupsController < ApplicationController
  def index
  end

  def update
  end

  # Crea la relación entre una especie y un grupo
  def create
    @species_group = SpeciesGroup.new
    species_params=params[:species_group]
    @species_group.group_id=species_params[:group_id]
    @species_group.species_id=species_params[:species_id]
    @species_group.species_group_state_id=species_params[:species_group_state_id]
    if @species_group.save
      if @species_group.species_group_state_id = 2
        send_email_to_admin(@species_group, current_user)
      end
      redirect_to group_path(id:species_params[:group_id])
    else
      # todo
    end
  end

  # Establece el estado de la relación entre una especie y un grupo
  def set_state
    @return=false
    species_group = SpeciesGroup.find(params[:id])
    species_group.species_group_state_id = params[:state]
    if species_group.save
      @return=true
      return true
    end
  end

  private

    def send_email_to_admin (species_group, user)
    #Envía notificación a administrador(es)
        group_admins = GroupUser.where(:group_id => species_group.group_id, :is_admin => true, :group_user_state_id => 1)
        group = Group.find(species_group.group_id)
        species = Species.find(species_group.species_id)
        if group_admins.blank?
          NotificationsMailer.new_species_group(user, group, species, "biomodelos@humboldt.org.co").deliver
        else
          group_admins.each do |f|
            NotificationsMailer.new_species_group(user, group, species, f.user.email).deliver
          end
        end
  end

end
