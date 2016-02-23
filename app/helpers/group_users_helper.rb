module GroupUsersHelper
	def send_email_to_admin (group_user)
		#Envía notificación a administrador(es)
        group_admins = GroupUser.where(:group_id => group_user.group_id, :is_admin => true)
        group = Group.find(group_user.group_id)
        if group_admins.blank?
          NotificationsMailer.new_user_group(User.find(group_user.user_id), group, "biomodelos@humboldt.org.co").deliver
        else
          group_admins.each do |f|
            NotificationsMailer.new_user_group(User.find(group_user.user_id), group, User.find(group_user.user_id).email).deliver
          end
        end
	end
end
