class MailerTasks

  def self.send_periodic_notifications
    following = UserRelationship.all
    my_groups = GroupUser.where(:group_user_state_id =>  1)
    user_list = '0'

    following.each do |f|
      user_id = ','+f.user_id.to_s
      user_list += user_id
    end

    my_groups.each do |f|
      user_id = ','+f.user_id.to_s
      user_list += user_id
    end

    users = User.find_by_sql("
                             SELECT u.id, u.name, u.email, u.last_email_send, u.periodicity_id
                             FROM users u
                             WHERE  u.id in ("+user_list+")
                             ")
    users.each do |f|
      if f.periodicity_id.blank?
        periodicity_id = 2
        days = 7
      else
        periodicity_id=f.periodicity_id
        case f.periodicity_id
          when 0
            days=0
          when 1
            days=1
          when 2
            days=7
          when 3
            days=30
        end
      end

      if f.last_email_send.blank?
        last_email_send = Date.today
      else
        last_email_send = f.last_email_send
      end

      # ---------------------------------------------------------------------
      last_email_send -= 300.day # Only for quick Test, comment as soon as posible
      # ---------------------------------------------------------------------

      if last_email_send + days.day <= Date.today && days!=0
        NotificationsMailer.send_mail_notifications(f.id, f.name, f.email, last_email_send, periodicity_id).deliver_now
      else
        date = last_email_send + days.day
        puts date.to_s
      end
    end

  end
end