class ContactMailer < ActionMailer::Base
  default from: "BioModelos <no-reply@biomodelos.humboldt.org.co>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact_us.subject
  #
  def contact_us(message)
    @message = message
    @datetime = DateTime.now
    mail to: "biomodelos@humboldt.org.co",  subject: "Feedback desde BioModelos"
  end

  # Función para Envío de mensajes de Administrador de grupo a mimbros de grupo
  def bulk_email_group (message, subject, group_emails, group_name, admin_name)
    @message = message
    @group_name=group_name
    @subject = subject
    @datetime = DateTime.now
    @admin_name = admin_name
    #mail to: mail,  subject: subject    # cDescomentar en producción
    mail bcc: group_emails,  subject: "Mensaje del moderador del grupo " + group_name # Comentar en producción
  end

  # Función para el envío de Invitaciones a Amigos externos a Biomodelos
  def email_invitation (message, name, email, group, user)
    @message = message
    @name = name
    @group = group
    @user = user
    mail to: email,  subject: "Has Recibido una invitación desde BioModelos"
  end
  
  # Envío de sugerencia de nuevo grupo al equipo BioModelos
  def email_new_group(message)
    @message = message
    @datetime = DateTime.now
    mail to: "biomodelos@humboldt.org.co",  subject: "Sugerencia de Nuevo Grupo BioModelos"
  end

end
