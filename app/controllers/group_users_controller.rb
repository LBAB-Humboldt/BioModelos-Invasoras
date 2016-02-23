class GroupUsersController < ApplicationController
  # Crea o actualiza la relación entre un usuario y un grupo
  def create
    group_params=params[:group_user]
    group_user1 = GroupUser.find_by_group_id_and_user_id(group_params[:group_id], current_user.id)
    if group_user1
      group_user1.is_admin=false
      case group_user1.group_user_state_id
        when 1
          group_user1.group_user_state_id = 4
        when 2
          group_user1.group_user_state_id = 2
        when 3
          group_user1.group_user_state_id = 2
        when 4
          group_user1.group_user_state_id = 2
      end
      if group_user1.save
        @message = true
        if group_user1.group_user_state_id = 2
          send_email_to_admin(group_user1)
        end
        redirect_to group_path(id:group_params[:group_id])
      else
        @message = false
      end
    else
      group_user = GroupUser.new
      group_user.group_id=group_params[:group_id]
      group_user.user_id=current_user.id
      group_user.group_user_state_id=2
      group_user.is_admin = false
      if group_user.save
        send_email_to_admin(group_user)
        redirect_to group_path(id:group_params[:group_id])
      else
        @message = false
      end
    end
  end

  def update
  end

  # Establece el estado de la relación entre un usuario y un grupo
  def set_state
    @return = false
    group_user = GroupUser.find(params[:id])
    group_user.group_user_state_id = params[:state]
    if group_user.save
      @return=true      
    end
    return @return
  end

private

  def send_email_to_admin (group_user)
    #Envía notificación a administrador(es)
        group_admins = GroupUser.where(:group_id => group_user.group_id, :is_admin => true, :group_user_state_id => 1)
        group = Group.find(group_user.group_id)
        if group_admins.blank?
          NotificationsMailer.new_user_group(User.find(group_user.user_id), group, "biomodelos@humboldt.org.co").deliver
        else
          group_admins.each do |f|
            NotificationsMailer.new_user_group(User.find(group_user.user_id), group, f.user.email).deliver
          end
        end
  end

end
